extends CharacterBody2D


var SPEED = 300.0


func _physics_process(delta: float) -> void:
	if not DialogueSignalBus.displaying_dialogue: 
		velocity = Vector2(0,0)
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var directionx := Input.get_axis("left", "right")
		var directiony := Input.get_axis("up", "down")
		if directionx:
			velocity.x = directionx * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if directiony:
			velocity.y = directiony * SPEED
		else:
			velocity.y = move_toward(0, velocity.y, SPEED)
		
		#velocity = velocity.normalized() 

		move_and_slide()
