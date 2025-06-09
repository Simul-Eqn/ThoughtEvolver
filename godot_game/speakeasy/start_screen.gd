extends CanvasLayer

@onready var startbutton = $Start


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startbutton.get_theme_stylebox("normal").bg_color = Color(0.1, 0.1, 0.1, 0.6)
	startbutton.get_theme_stylebox("pressed").bg_color = Color(0.1, 0.1, 0.1, 0.6)
	startbutton.get_theme_stylebox("hover").bg_color = Color(0.1, 0.1, 0.1, 0.6)
	startbutton.get_theme_stylebox("focus").bg_color = Color(0.1, 0.1, 0.1, 0.6)
	startbutton.get_theme_stylebox("disabled").bg_color = Color(0.1, 0.1, 0.1, 0.6)
	startbutton.get_theme_stylebox("focus").border_width_top = 0 
	startbutton.get_theme_stylebox("focus").border_width_bottom = 0 
	startbutton.get_theme_stylebox("focus").border_width_left = 0 
	startbutton.get_theme_stylebox("focus").border_width_right = 0 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit() 


func _on_how_to_play_pressed() -> void:
	get_tree().change_scene_to_file("res://guide.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://credits.tscn")
