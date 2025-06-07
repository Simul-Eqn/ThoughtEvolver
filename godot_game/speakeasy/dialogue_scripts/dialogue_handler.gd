extends Node 

@onready var embToText = $EmbToText
@onready var textToEmb = $TextToEmb

var popsize = 6 
var thoughts = [] 
var embs = [] 
var selecteds = []

var persistence = 0.0 
var randomness = 0.0 


func thoughts_to_embs(): 
	#print("THOUGYHTS TOE MBS")
	# from list of thoughts, get embs 
	if embs == []: 
		embs = [0,0,0,0,0,0,0]
	for i in range(popsize): 
		#print(i)
		embs[i] = await textToEmb.text_to_emb(thoughts[i])
		#print("EMB IS", embs[i])

func embs_to_thoughts(): 
	#print("EMBS TO THOUGHTS")
	# from list of embs, update thoughts 
	for i in range(popsize): 
		#print("BEFORE:", thoughts[i])
		thoughts[i] = await embToText.emb_to_text(embs[i], 0.0)
	
func emb_to_text(emb:Array): 
	return await embToText.emb_to_text(emb, randomness) 

func thoughts_to_embs_to_thoughts(): 
	await thoughts_to_embs() 
	await embs_to_thoughts() 


# genetic algorithm part -- DIFFEVO 

# ADAPTED FROM: 
#------------------------------------------------------------------------------+
#
#   Nathan A. Rooy
#   A simple, bare bones, implementation of differential evolution with Python
#   August, 2017
#
#------------------------------------------------------------------------------+


func random_sample_from_list(lst, num:int=3): # but updates the list so dangerous 
	var sample = []
	for i in range(num):
		var x = randi()%len(lst)
		sample.append(lst[x])
		lst.erase(x)
	return sample 


func ensure_bounds(vec, l=-0.1, h=0.1):
	var vec_new = []
	# cycle through each variable in vector 
	for i in range(len(vec)):

		# variable exceedes the minimum boundary
		if vec[i] < l:
			vec_new.append(l)

		# variable exceedes the maximum boundary
		if vec[i] > h:
			vec_new.append(h)

		# the variable is fine
		if l <= vec[i] and vec[i] <= h:
			vec_new.append(vec[i])

	return vec_new
	


func random_with_bound(lower, upper): # currently uniform but well 
	return lower + (upper-lower)*randi() 



#--- SOLVE --------------------------------------------+
func regenerate_thoughts(mutate=0.5, recombination=0.7):
	# cycle through each individual in the population
	for j in range(0, popsize):
		
		if selecteds[j]: 
			#print("MUTATING J")
			# if it's selected, it needs to be replaced 

			#--- MUTATION (step #3.A) ---------------------+
			
			# select three random vector index positions [0, popsize), not including current vector (j)
			var candidates = [] 
			for c in range(popsize): 
				if (c != j): 
					candidates.append(c)
			var random_index = random_sample_from_list(candidates, 3)

			var x_1 = embs[random_index[0]]
			var x_2 = embs[random_index[1]]
			var x_3 = embs[random_index[2]]
			var x_t = embs[j]     # target individual

			# subtract x3 from x2, and create a new vector (x_diff)
			var x_diff = [] 
			for i in range(len(x_2)): 
				x_diff.append(x_2[i] - x_3[i]) 

			# multiply x_diff by the mutation factor (F) and add to x_1
			var v_donor = [] 
			for i in range(len(x_1)): 
				v_donor.append(x_1[i] + mutate * x_diff[i]) 
			
			v_donor = ensure_bounds(v_donor)

			#--- RECOMBINATION (step #3.B) ----------------+

			var v_trial = []
			for k in range(len(x_t)):
				if randf() <= recombination:
					#print("DONOR")
					v_trial.append(persistence*x_t[k] + (1-persistence)*v_donor[k])
				else:
					v_trial.append(x_t[k])
			
			# v_trial is the final embedding! 
			embs[j] = v_trial 
			thoughts[j] = await emb_to_text(v_trial)
			
			selecteds[j] = false 
