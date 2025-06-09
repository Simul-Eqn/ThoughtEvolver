extends Node2D

@onready var coffeeshop_npc = $"01_coffeeshop" 
@onready var watercooler_npc = $"02_watercooler"
@onready var familygathering_npc = $"03_familygathering" 
@onready var coffeeshop_bg = $CoffeeshopBg
@onready var watercooler_bg = $WatercoolerBg
@onready var familygathering_bg = $FamilygatheringBg

@onready var player = $player

@onready var ws1 = $"Workstation-computer"
@onready var ws2 = $"Workstation-computer2" 
@onready var ws3 = $"Workstation-computer3" 
@onready var ws4 = $"Workstation-computer4" 
@onready var ws5 = $"Workstation-copier"

@onready var coffeeshop_fg = $CoffeeshopFg

@onready var stage_label = $StageLabel



var currLevel = 1 


var lvl_texts = ['Hacker', 
				'Stage 1:\nCoffeeshop Encounter', 
				'[color=black]Stage 2:\nWatercooler Meeting[/color]', 
				'[b][color=red]FINAL BOSS:[/color][/b]\nFamily Meeting', 'padding']




func setLevel(level): 
	if level == 0: # START SCREEN 
		coffeeshop_npc.hide() 
		coffeeshop_npc.self_active = false 
		watercooler_npc.hide() 
		watercooler_npc.hide_spawns() 
		watercooler_npc.self_active = false 
		familygathering_npc.hide() 
		familygathering_npc.self_active = false 
		hide_wss()
	elif level == 1: 
		coffeeshop_npc.show() 
		coffeeshop_npc.self_active = true 
		watercooler_npc.hide() 
		watercooler_npc.hide_spawns() 
		watercooler_npc.self_active = false 
		familygathering_npc.hide() 
		familygathering_npc.self_active = false 
		coffeeshop_bg.show() 
		watercooler_bg.hide() 
		familygathering_bg.hide() 
		coffeeshop_fg.show() 
		hide_wss() 
	elif level == 2: 
		coffeeshop_npc.hide() 
		coffeeshop_npc.self_active = false 
		watercooler_npc.show() 
		watercooler_npc.show_spawns() 
		watercooler_npc.self_active = true 
		familygathering_npc.hide() 
		familygathering_npc.self_active = false
		coffeeshop_bg.hide() 
		watercooler_bg.show() 
		familygathering_bg.hide() 
		coffeeshop_fg.hide() 
		show_wss()
	elif level == 3: 
		coffeeshop_npc.hide() 
		coffeeshop_npc.self_active = false 
		watercooler_npc.hide() 
		watercooler_npc.hide_spawns() 
		watercooler_npc.self_active = false 
		familygathering_npc.show() 
		familygathering_npc.self_active = true 
		coffeeshop_bg.hide() 
		watercooler_bg.hide() 
		familygathering_bg.show() 
		coffeeshop_fg.hide() 
		hide_wss() 
	elif level == 4: # END SCREEN 
		get_tree().change_scene_to_file("res://end_screen.tscn")
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
	if currLevel < 4: 
		stage_label.text = lvl_texts[currLevel]
		animateStageLabel() 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	activateNPCs()
	DialogueSignalBus.connect("activateNPCs", activateNPCs) 
	DialogueSignalBus.connect("deactivateNPCs", deactivateNPCs)
	DialogueSignalBus.connect("nextLevel", nextLevel)
	DialogueSignalBus.num_passes = 0 
	DialogueSignalBus.response = "" 
	
	player.show() 
	
	hide_wss() 
	
	stage_label.text = lvl_texts[1]
	animateStageLabel() 
	
	# hide text 
	var tween = get_tree().create_tween()
	tween.tween_property(stage_label, "modulate:a", 0, 0.01)
	tween.play()
	await tween.finished
	tween.kill()

var fade_duration = 1 

func animateStageLabel(): 
	var tween2 = get_tree().create_tween()
	tween2.tween_property(stage_label, "modulate:a", 1, fade_duration)
	tween2.play()
	await tween2.finished
	tween2.kill()
	
	await get_tree().create_timer(1.0).timeout
	
	var tween = get_tree().create_tween()
	tween.tween_property(stage_label, "modulate:a", 0, fade_duration)
	tween.play()
	await tween.finished
	tween.kill()
	
	
	


func hide_wss(): 
	ws1.hide() 
	ws2.hide() 
	ws3.hide() 
	ws4.hide() 
	ws5.hide() 
	
func show_wss(): 
	ws1.show() 
	ws2.show() 
	ws3.show() 
	ws4.show() 
	ws5.show() 




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
