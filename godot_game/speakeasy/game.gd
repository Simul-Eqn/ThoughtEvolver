extends Node2D

@onready var coffeeshop_npc = $"01_coffeeshop" 
@onready var watercooler_npc = $"02_watercooler"
@onready var familygathering_npc = $"03_familygathering" 
@onready var coffeeshop_bg = $CoffeeshopBg
@onready var fg_texture = $FgTexture

var coffeeshop_fg = load("res://assets/coffeeshopinner.png")

var currLevel = 1 




func setLevel(level): 
	if level == 0: 
		coffeeshop_npc.hide() 
		coffeeshop_npc.self_active = false 
		watercooler_npc.hide() 
		watercooler_npc.hide_spawns() 
		watercooler_npc.self_active = false 
		familygathering_npc.hide() 
		familygathering_npc.self_active = false 
	elif level == 1: 
		coffeeshop_npc.show() 
		coffeeshop_npc.self_active = true 
		watercooler_npc.hide() 
		watercooler_npc.hide_spawns() 
		watercooler_npc.self_active = false 
		familygathering_npc.hide() 
		familygathering_npc.self_active = false 
		fg_texture.set_texture(coffeeshop_fg)
		fg_texture.show()
	elif level == 2: 
		coffeeshop_npc.hide() 
		coffeeshop_npc.self_active = false 
		watercooler_npc.show() 
		watercooler_npc.show_spawns() 
		watercooler_npc.self_active = true 
		familygathering_npc.hide() 
		familygathering_npc.self_active = false
	elif level == 3: 
		coffeeshop_npc.hide() 
		coffeeshop_npc.self_active = false 
		watercooler_npc.hide() 
		watercooler_npc.hide_spawns() 
		watercooler_npc.self_active = false 
		familygathering_npc.show() 
		familygathering_npc.self_active = true 
	elif level == 4: 
		coffeeshop_npc.hide() 
		coffeeshop_npc.self_active = false 
		watercooler_npc.hide() 
		watercooler_npc.hide_spawns() 
		watercooler_npc.self_active = false 
		familygathering_npc.hide() 
		familygathering_npc.self_active = false 

func deactivateNPCs(): 
	setLevel(0) 

func activateNPCs(): 
	setLevel(currLevel)

func nextLevel(): 
	currLevel += 1 
	activateNPCs() 



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	activateNPCs()
	DialogueSignalBus.connect("activateNPCs", activateNPCs) 
	DialogueSignalBus.connect("deactivateNPCs", deactivateNPCs)
	DialogueSignalBus.connect("nextLevel", nextLevel)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
