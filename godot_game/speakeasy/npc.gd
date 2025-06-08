extends Area2D

# inspired by https://www.youtube.com/watch?v=LMSbPkNgnWA 

@export var dialogue_key = "watercoolerNPC" 
var area_active = false 
@onready var sprite = $Sprite
var self_active = false 
@onready var dialogueBox = $dialogueBox
@onready var nameLabel = $dialogueBox/nameLabel
@onready var textLabel = $dialogueBox/textLabel
@onready var evaluator = $evaluate

var npcCls = preload("res://npc.tscn")

signal finishedEval() 



var normal_texture = {
	'coffeeshop': load("res://assets/coffeeshop_small.png"), 
	'watercooler': load("res://assets/watercooler.png"), 
	'watercoolerNPC': load("res://assets/watercooler_NPC_small.png"), 
	'familygathering': load("res://assets/familygathering_small.png"),
}
var active_texture = {
	'coffeeshop': load("res://assets/coffeeshop_small_bright.png"), 
	'watercooler': load("res://assets/watercooler_bright.png"), 
	'watercoolerNPC': load("res://assets/watercooler_NPC_small.png"), 
	'familygathering': load("res://assets/familygathering_small_bright.png"),
}
var scales = {
	'coffeeshop': Vector2(8.0, 8.0), 
	'watercooler': Vector2(2.0, 2.0), 
	'watercoolerNPC': Vector2(8.0, 8.0),
	'familygathering': Vector2(8.0, 8.0),
}


var questions = {
	"coffeeshop": "Hey! Fancy meeting you here. What's your go-to coffee order?", 
	"watercooler": "Oh hi [y/n], how was your weekend?", 
	'familygathering': "So, how's life?", 
}

var names = {
	"coffeeshop": "  (old friend) ", 
	"watercooler": "  Colleague  ", 
	'familygathering': "  Extended Family  ", 
} 

var pass_texts = {
	"coffeeshop": "Oh nice! I'm a cappucino fan. Let's have coffee together :)", 
	"watercooler": "  Colleague  ", 
	'familygathering': "Oh that's quite cool!", 
} 

var fail_texts = {
	"coffeeshop": "Oh, cool. Well... enjoy your coffee :]", 
	"watercooler": "Huh, sounds relaxing. Anyway, I should get back to work.", 
	'familygathering': "Oh... Well, sounds like you're keeping busy. Nice catching up", 
} 


var boxOffset = {
	"coffeeshop": Vector2(18, -169), 
	"watercooler": Vector2(31, 80), 
	'watercoolerNPC': Vector2(0,0), 
	'familygathering': Vector2(-276, -179), 
}


var mode = 0 
'''
0 is default 
1 is displaying first dialogue 
2 is user responding / deciding 
3 is responding back 
'''

var spawned_npc = null 

func hide_spawns(): 
	if (spawned_npc != null): 
		spawned_npc.hide() 

func show_spawns(): 
	if (spawned_npc != null): 
		spawned_npc.show() 

func _input(event): 
	if dialogue_key == 'watercoolerNPC': 
		return # do nothing 
	if area_active and event.is_action_pressed("ui_accept") and self_active: 
		if mode == 0: 
			if dialogue_key == "watercooler": 
				# DO EXTRA HEHE show the watercooler NPC 
				var npc_instance = npcCls.instantiate() 
				npc_instance.dialogue_key = "watercoolerNPC" 
				npc_instance.global_position = global_position + Vector2(100, 0)
				get_parent().add_child(npc_instance)
				spawned_npc = npc_instance
				spawned_npc.show() 
			#print("SPACE") 
			nameLabel.text = names[dialogue_key] 
			textLabel.text = questions[dialogue_key]
			dialogueBox.show() 
			mode = 1 
			DialogueSignalBus.displaying_dialogue = true 
		elif mode == 1: 
			mode = 2 
			DialogueSignalBus.emit_signal("display_dialogue", dialogue_key)
			dialogueBox.hide() 
		elif mode == 2: 
			DialogueSignalBus.emit_signal("playerHideDialogue")
			
			if eval == "evaluating...":
				await finishedEval 
			if eval == 'pass': 
				textLabel.text = pass_texts[dialogue_key] 
			elif eval == 'fail': 
				textLabel.text = fail_texts[dialogue_key] 
			else: 
				textLabel.text = eval+' when deciding if you pass or fail...'
			
			dialogueBox.show() 
			mode = 3 
		elif mode == 3: 
			dialogueBox.hide() 
			DialogueSignalBus.emit_signal("nextLevel")
			mode = 0 
			DialogueSignalBus.displaying_dialogue = false 
			

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_active = false 
	sprite.texture = normal_texture[dialogue_key] 
	sprite.scale = scales[dialogue_key] 
	#self_active = false 
	dialogueBox.position = boxOffset[dialogue_key]
	dialogueBox.hide() 
	mode = 0 
	
	DialogueSignalBus.connect("npcStartEval", startEval)


func _on_body_entered(body: Node2D) -> void:
	area_active = true 
	sprite.texture = active_texture[dialogue_key] #load("res://assets/bbbbb.png")
	

func _on_body_exited(body: Node2D) -> void:
	area_active = false 
	sprite.texture = normal_texture[dialogue_key] #load("res://assets/aaaaa.png")




var eval = "not loaded" 
func startEval(): 
	if self_active and (dialogue_key != "watercoolerNPC"): 
		#print("STARTEAL")
		eval = 'evaluating...'
		eval = await evaluator.evaluate(questions[dialogue_key], DialogueSignalBus.response)
		#print("EVAL: ", eval)
		emit_signal("finishedEval")
