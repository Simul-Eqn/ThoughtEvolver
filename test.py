from diffevo import de_simple

i = 0 
def cost(x):
    global i  
    i = (i+1)%10 
    return int(i!=0) 

bounds = [(-1,1),(-1,1)]            # bounds [(x1_min, x1_max), (x2_min, x2_max),...]
popsize = 10                        # population size, must be >= 4
mutate = 0.5                        # mutation factor [0,2]
recombination = 0.7                 # recombination rate [0,1]
maxiter = 20                        # max number of generations

de_simple.minimize(cost, bounds, popsize, mutate, recombination, maxiter)
