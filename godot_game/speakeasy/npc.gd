extends Area2D

@export var dialogue_key = "" 
var area_active = false 
@onready var sprite = $Sprite


func _input(event): 
	if area_active and event.is_action_pressed("ui_accept"): 
		#print("SPACE") 
		DialogueSignalBus.emit_signal("display_dialogue", dialogue_key)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node2D) -> void:
	area_active = true 
	sprite.texture = load("res://assets/bbbbb.png")
	

func _on_body_exited(body: Node2D) -> void:
	area_active = false 
	sprite.texture = load("res://assets/aaaaa.png")
