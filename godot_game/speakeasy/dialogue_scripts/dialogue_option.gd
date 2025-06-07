extends Control

signal buttonPressed() 

@export var idx = 0
@onready var button = $Button 
@onready var btnLabel = $Button/Label 

func _ready() -> void:
	#button.add_theme_color_overide("bg", Color(0,0,0,0))
	button.get_theme_stylebox("normal").bg_color = Color(0,0,0,0)
	button.get_theme_stylebox("pressed").bg_color = Color(0,0,0,0)
	button.get_theme_stylebox("hover").bg_color = Color(0,0,0,0)
	button.get_theme_stylebox("focus").bg_color = Color(0,0,0,0)
	button.get_theme_stylebox("focus").border_width_top = 0 
	button.get_theme_stylebox("focus").border_width_bottom = 0 
	button.get_theme_stylebox("focus").border_width_left = 0 
	button.get_theme_stylebox("focus").border_width_right = 0 
	button.get_theme_stylebox("disabled").bg_color = Color(0,0,0,0)
	button.icon = load("res://assets/dialogue_normal.svg")

func _on_button_pressed() -> void:
	emit_signal("buttonPressed")
