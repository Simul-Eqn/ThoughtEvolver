extends Control

@onready var background = $background
@onready var text_label = $SceneTextLabel
@onready var curr_mode = $currMode
@onready var nextModeBtn = $nextMode
@onready var nextModeLabel = $nextMode/nextModeLabel
@onready var dialogueHandler = $DialogueHandler
@onready var persistenceSlider = $PersistenceSlider
@onready var persistenceValueLabel = $PersistenceValue 
@onready var persistenceLabel = $PersistenceLabel
@onready var randomnessSlider = $RandomnessSlider
@onready var randomnessLabel = $RandomnessLabel
@onready var randomnessValueLabel = $RandomnessValue
@onready var regenThoughtsBtn = $regenerateThoughts
@onready var restartBtn = $RestartButton
var dialogueOptionCls = preload("res://dialogue_option.tscn")

var dialogueOptions = [] 
var doPoss = [
	Vector2(20, 220), 
	Vector2(150, 385), 
	Vector2(370, 425), 
	Vector2(590, 425), 
	Vector2(810, 385), 
	Vector2(940, 220), 
]

var mode = 0 
# 0 is nothing 
# 1 is thinking 
# 2 is selecting final 

var questions = {
	"coffeeshop": "Hey! Fancy meeting you here. What's your go-to coffee order?", 
	"watercooler": "Oh hi [y/n], how was your weekend?", 
	'familygathering': "So, how's life?", 
}
var initThoughts = {
	"coffeeshop": [
		'Black coffee... but is that too basic?', 
		'Oh no, small talk. Abort!', 
		'Can I just smile and nod?', 
		'Hello...!!', 
		'Who were you again...?', 
		'Whatever you order :)', 
	], 
	"watercooler": [
		'I... just... did nothing...', 
		'Weekend? What weekend? Time is a blur...', 
		'I did my laundry', 
		'Do they really care...?', 
		'Uhh... How was your weekeend?', 
		'I binge-watched a show... but that\'s boring...', 
	], 
	"familygathering": [
		'Do they actually want to know, or is this small talk?', 
		'I\'ve mostly just been drowned in work...?', 
		'Same as always... is that an okay response?', 
		'Do they really care...?', 
		'Oh no you\'re gonna ask me about my friendships...', 
		'Why did the chicken cross the road?', 
	], 
}

var currQnKey = "" 

# UI part -----------------------------------------------------------------------------------
func _ready(): 
	for i in range(dialogueHandler.popsize): 
		var dialogue_option_instance = dialogueOptionCls.instantiate()
		dialogue_option_instance.idx = i 
		dialogue_option_instance.global_position = doPoss[i] 
		add_child(dialogue_option_instance)
		dialogueOptions.append(dialogue_option_instance)
		
		var updateSelected = func (): 
			dialogueHandler.selecteds[i] = not dialogueHandler.selecteds[i] 
			#print(dialogueHandler.selecteds)
			if mode == 2: # finalizing so deselect others 
				for j in range(dialogueHandler.popsize): 
					if (j != i): 
						dialogueHandler.selecteds[j] = false 
			updateSelectedStates() 
		
		dialogue_option_instance.connect("buttonPressed", updateSelected)
		
	loadingDialogueOptionTexts() 
		
	self.hide()
	DialogueSignalBus.connect("display_dialogue", on_display_dialogue)
	mode = 0 

var dialogueNormal = load("res://assets/dialogue_normal.svg")
var dialogueHighlight = load("res://assets/dialogue_highlight.svg")
var dialogueDelete = load("res://assets/dialogue_delete.svg")

func updateSelectedStates(): 
	if mode == 1:
		# selected should be darker 
		for i in range(dialogueHandler.popsize): 
			if dialogueHandler.selecteds[i]: 
				dialogueOptions[i].button.icon = dialogueDelete 
			else: 
				dialogueOptions[i].button.icon = dialogueNormal 
	else: 
		# selected is brighter 
		for i in range(dialogueHandler.popsize): 
			if dialogueHandler.selecteds[i]: 
				dialogueOptions[i].button.icon = dialogueHighlight 
			else: 
				dialogueOptions[i].button.icon = dialogueNormal 

func _on_restart_button_pressed() -> void:
	loadingDialogueOptionTexts() 
	resetDialogueOptionTexts() 

func setMode(newMode): 
	if newMode == 1: 
		curr_mode.text = "Current Mode: Thinking"
		nextModeLabel.text = "Finish Thinking!" 
		mode = 1 
		regenThoughtsBtn.show() 
		restartBtn.show() 
		persistenceSlider.show() 
		persistenceLabel.show() 
		persistenceValueLabel.show()
		randomnessSlider.show() 
		randomnessLabel.show() 
		randomnessValueLabel.show()
	elif newMode == 2: 
		curr_mode.text = "Current Mode: Finalizing"
		nextModeLabel.text = "Confirm!"
		mode = 2 
		for i in range(dialogueHandler.popsize): 
			dialogueHandler.selecteds[i] = false 
		updateSelectedStates()
		regenThoughtsBtn.hide() 
		restartBtn.hide() 
		persistenceSlider.hide() 
		persistenceLabel.hide() 
		persistenceValueLabel.hide()
		randomnessSlider.hide() 
		randomnessLabel.hide() 
		randomnessValueLabel.hide()
	elif newMode == 3: 
		finish() 
	else: 
		print("UNKNOWN SET MODE", newMode)

func thoughts_embs_then_update(): 
	await dialogueHandler.thoughts_to_embs_to_thoughts() # to prevent regeneration giving diff resutls yk 
	updateDialogueOptionTexts()

func resetDialogueOptionTexts(): 
	loadingDialogueOptionTexts() 
	dialogueHandler.thoughts = []#"hi", "relaxed", "sad", "bye", "good", "bad"] 
	for i in range(dialogueHandler.popsize): 
		dialogueHandler.thoughts.append(initThoughts[currQnKey][i])
	thoughts_embs_then_update()
	dialogueHandler.selecteds = [false, false, false, false, false, false]
	setMode(1) 

func on_display_dialogue(text_key): 
	DialogueSignalBus.emit_signal("deactivateNPCs")
	dialogueHandler.selecteds = [false, false, false, false, false, false]
	updateSelectedStates() 
	currQnKey = text_key 
	self.show()
	#DialogueSignalBus.displaying_dialogue = true 
	resetDialogueOptionTexts()
	text_label.text = questions[text_key] 
	

func _on_next_mode_pressed() -> void:
	setMode(mode + 1)

func finish(): 
	# set response 
	DialogueSignalBus.response = "[No response]" 
	for i in range(dialogueHandler.popsize): 
		if dialogueHandler.selecteds[i]: 
			DialogueSignalBus.response = dialogueHandler.thoughts[i] 
			break 
	
	dialogueHandler.selecteds = [false, false, false, false, false, false]
	
	text_label.text = "" 
	self.hide() 
	#DialogueSignalBus.displaying_dialogue = false 
	
	DialogueSignalBus.emit_signal("activateNPCs")
	DialogueSignalBus.emit_signal("playerDisplayDialogue")
	DialogueSignalBus.emit_signal("npcStartEval")

func loadingDialogueOptionTexts(): 
	for i in range(len(dialogueOptions)): 
		dialogueOptions[i].btnLabel.text = "Loading..."

func updateDialogueOptionTexts(): 
	for i in range(len(dialogueOptions)): 
		dialogueOptions[i].btnLabel.text = dialogueHandler.thoughts[i] 





# slider 
func _on_persistence_slider_value_changed(value: float) -> void:
	dialogueHandler.persistence = value/100
	persistenceValueLabel.text = str(dialogueHandler.persistence)

func _on_randomness_slider_value_changed(value: float) -> void:

	dialogueHandler.randomness = value/100 
	randomnessValueLabel.text = str(dialogueHandler.randomness)



# genetic algorithm part ------------------------------------------------------------------------

func _on_regenerate_thoughts_pressed() -> void:
	await dialogueHandler.regenerate_thoughts() 
	#print("NEW THOUGHTS") 
	#print(dialogueHandler.thoughts)
	updateDialogueOptionTexts()
	updateSelectedStates()
