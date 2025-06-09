extends CanvasLayer

@onready var prompt = $Prompt
@onready var bg = $bg

@onready var quitButton = $Quit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# set button style 
	quitButton.get_theme_stylebox("normal").bg_color = Color(0.1, 0.1, 0.1, 0.6)
	quitButton.get_theme_stylebox("pressed").bg_color = Color(0.1, 0.1, 0.1, 0.6)
	quitButton.get_theme_stylebox("hover").bg_color = Color(0.1, 0.1, 0.1, 0.6)
	quitButton.get_theme_stylebox("focus").bg_color = Color(0.1, 0.1, 0.1, 0.6)
	quitButton.get_theme_stylebox("disabled").bg_color = Color(0.1, 0.1, 0.1, 0.6)
	quitButton.get_theme_stylebox("focus").border_width_top = 0 
	quitButton.get_theme_stylebox("focus").border_width_bottom = 0 
	quitButton.get_theme_stylebox("focus").border_width_left = 0 
	quitButton.get_theme_stylebox("focus").border_width_right = 0 
	
	
	#DialogueSignalBus.num_passes = 0 # for testing 
	
	# set bg 
	if DialogueSignalBus.num_passes == 0: 
		bg.texture = load("res://assets/end_bg0_v2.svg")
	elif DialogueSignalBus.num_passes == 1: 
		bg.texture = load("res://assets/end_bg1.svg")
	elif DialogueSignalBus.num_passes == 2: 
		bg.texture = load("res://assets/end_bg2.svg")
	elif DialogueSignalBus.num_passes == 3: 
		bg.texture = load("res://assets/end_bg3.svg")
	else: 
		bg.texture = load("res://icon.svg")
	
	# set text 
	if DialogueSignalBus.num_passes == 0: 
		prompt.text = "You have navigated [font_size=80][color=red]0[/color][/font_size] social situations non-awkwardly...\n\n[s][fade length=40]But would you treat this as a loss?[/fade][/s]"
	elif DialogueSignalBus.num_passes == 1: 
		prompt.text = "\n\n[color=black]You have successfully navigated\n[font_size=100]1[/font_size]\nsocial situation non-awkwardly!![/color]"
	elif DialogueSignalBus.num_passes == 2: 
		prompt.text = "[color=#798a79]Wow! You have navigated [font_size=100][color=#28b82b]2[/color][/font_size] social situations non-awkwardly!!\n\n[font_size=15](That's more than the dev ever got!!)[/font_size][/color]"
	elif DialogueSignalBus.num_passes == 3: 
		prompt.text = "\n\nYou are a social mastermind, navigating\n[rainbow][b][font_size=100]A L L[/font_size][/b][/rainbow]\nsocial situations non-awkwardly!"
	else: 
		prompt.text = 'You have either glitched the game or hacked the game!'


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_quit_pressed() -> void:
	get_tree().quit() 

func _on_back_to_title_pressed() -> void:
	get_tree().change_scene_to_file("res://start_screen.tscn")
