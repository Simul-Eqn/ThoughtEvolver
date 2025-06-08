extends CharacterBody2D

# inspired by https://www.youtube.com/watch?v=LMSbPkNgnWA 

@onready var sprite = $Sprite2D 
@onready var dialogueBox = $dialogueBox
@onready var nameLabel = $dialogueBox/nameLabel
@onready var textLabel = $dialogueBox/textLabel

var default_dialoguebox_pos 

func _ready() -> void:
	dialogueBox.hide() 
	DialogueSignalBus.connect("playerDisplayDialogue", display_response) 
	DialogueSignalBus.connect("playerHideDialogue", hide_response) 
	default_dialoguebox_pos = dialogueBox.position 

var SPEED = 200.0

var current_state = IDLE 
var dir = Vector2.RIGHT 

enum {
	IDLE, 
	MOVE
}

func _process(delta): 
	if current_state==IDLE: 
		sprite.play("idle")
	elif (current_state == MOVE) and (not DialogueSignalBus.displaying_dialogue): 
		if dir.x == -1: 
			sprite.play("walk_left")
		elif dir.x == 1: 
			sprite.play("walk_right")
		elif dir.y == -1: 
			sprite.play("walk_up") 
		else: 
			sprite.play("walk_down")
		
		velocity = dir * SPEED 
		
		move_and_slide()

func _physics_process(delta: float) -> void:
	if not DialogueSignalBus.displaying_dialogue: 
		velocity = Vector2(0,0)
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var directionx := Input.get_axis("left", "right")
		var directiony := Input.get_axis("up", "down")
		if (directionx == 0) and (directiony == 0): 
			current_state = IDLE 
		elif current_state == IDLE: 
			# start moving from idle 
			if directionx == 1: 
				dir = Vector2.RIGHT 
			elif directionx==-1: 
				dir = Vector2.LEFT 
			elif directiony == 1: 
				dir = Vector2.UP 
			elif directiony==-1: 
				dir = Vector2.DOWN 
			else: 
				print("ERROR MOVEMENT 142244")
			
			current_state = MOVE 
		
		elif current_state == MOVE: 
			# change direction if needed 
			var wrong_dirn = false 
			if (directionx != 1) and (dir == Vector2.RIGHT): 
				wrong_dirn = true 
			if (directionx !=- 1) and (dir == Vector2.LEFT): 
				wrong_dirn = true 
			if (directiony != -1) and (dir == Vector2.UP): 
				wrong_dirn = true 
			if (directiony != 1) and (dir == Vector2.DOWN): 
				wrong_dirn = true 
			
			if wrong_dirn: 
				# there's already a dirn otherwise it'd be set to idle already 
				if directionx == 1: 
					dir = Vector2.RIGHT 
				elif directionx==-1: 
					dir = Vector2.LEFT 
				elif directiony == -1: 
					dir = Vector2.UP 
				elif directiony==1: 
					dir = Vector2.DOWN 
				else: 
					print("ERROR MOVEMENT 142244")
			
				current_state = MOVE 
				
			
		'''if directionx:
			velocity.x = directionx * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if directiony:
			velocity.y = directiony * SPEED
		else:
			velocity.y = move_toward(0, velocity.y, SPEED)'''
		
		move_and_slide()
	else: 
		current_state = IDLE # set mode to idle 


func display_response(): 
	dialogueBox.position = default_dialoguebox_pos 
	if dialogueBox.global_position.y < 0: 
		dialogueBox.global_position.y = 0 
	nameLabel.text = "Player"
	textLabel.text = DialogueSignalBus.response 
	dialogueBox.show() 

func hide_response(): 
	dialogueBox.hide() 
