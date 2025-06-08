extends CanvasLayer

@onready var prompt = $Prompt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prompt.text = "You have successfully navigated "+str(DialogueSignalBus.num_passes)+" social situations non-awkwardly!!"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_quit_pressed() -> void:
	get_tree().quit() 

func _on_back_to_title_pressed() -> void:
	get_tree().change_scene_to_file("res://start_screen.tscn")
