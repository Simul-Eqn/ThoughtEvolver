extends Node2D

@onready var closebutton = $Close/CloseButton
@onready var closebuttontext = $Close

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(closebutton.get_theme_stylebox("normal").bg_color)
	
	closebutton.get_theme_stylebox("normal").bg_color = Color(0,0,0,0)
	closebutton.get_theme_stylebox("pressed").bg_color = Color(0,0,0,0)
	closebutton.get_theme_stylebox("hover").bg_color = Color(0,0,0,0)
	closebutton.get_theme_stylebox("focus").bg_color = Color(0,0,0,0)
	closebutton.get_theme_stylebox("focus").border_width_top = 0 
	closebutton.get_theme_stylebox("focus").border_width_bottom = 0 
	closebutton.get_theme_stylebox("focus").border_width_left = 0 
	closebutton.get_theme_stylebox("focus").border_width_right = 0 
	closebutton.get_theme_stylebox("disabled").bg_color = Color(0,0,0,0)
	
	closebutton.show() 
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
	print("PERSEED")
	get_tree().change_scene_to_file("res://start_screen.tscn")
