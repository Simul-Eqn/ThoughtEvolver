extends RigidBody2D

@onready var c = $CollisionShape2D
var v_scale = 300 
var a_scale = 3 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

var i = 0 

func _integrate_forces(state): 
	if i==0: 
		state.linear_velocity += Vector2(v_scale*randf(), v_scale*randf())
		state.angular_velocity += a_scale*(randf()-0.5)*2 
		i += 1 
	else: 
		state.linear_velocity = state.linear_velocity.normalized()*v_scale
		if abs(state.angular_velocity) < a_scale: 
			state.angular_velocity *= 1.1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
