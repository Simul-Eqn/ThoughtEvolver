extends Button

var is_rotating = false 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_rotating=false
	get_theme_stylebox("pressed").bg_color = Color(0,0,0,0)
	get_theme_stylebox("focus").bg_color = Color(0,0,0,0)
	get_theme_stylebox("focus").border_width_top = 0
	get_theme_stylebox("focus").border_width_bottom = 0
	get_theme_stylebox("focus").border_width_left = 0
	get_theme_stylebox("focus").border_width_right = 0
	get_theme_stylebox("hover").bg_color = Color(0,0,0,0)
	get_theme_stylebox("normal").bg_color = Color(0,0,0,0)

	


func _physics_process(delta: float) -> void:
	if is_rotating: 
		rotation += 3*delta 
		if rotation > deg_to_rad(360): 
			rotation = 0 
			is_rotating = false 
			disabled = false 


func _on_pressed() -> void:
	disabled = true 
	is_rotating=true
