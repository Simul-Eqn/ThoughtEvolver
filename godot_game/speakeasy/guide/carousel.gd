extends Node2D

@onready var leftButton = $LeftButton
@onready var rightButton = $RightButton
@onready var img = $TextureRect
@onready var text = $Label

var imgs = {
	-1: load("res://assets/guide/neg1_start.png"),
	0: load("res://assets/guide/dialogue_0.png"), 
	1: load("res://assets/guide/dialogue_1.png"), 
	2: load("res://assets/guide/dialogue_2.png"), 
	3: load("res://assets/guide/dialogue_3.png"), 
	4: load("res://assets/guide/dialogue_4.png"), 
	5: load("res://assets/guide/5_failure.png"), 
	6: load("res://assets/guide/6_success.png"), 
	7: load("res://assets/guide/7_win.png"), 
	8: load("res://assets/guide/8_loading.png"), 
}
var texts = {
	-1: "Small talk is so easy... right? Experience small talk through the lens of someone awkward with SpeakEasy!", 
	0: "Press space to interact with characters to enter gameplay. This is the screen for the main game.", 
	1: "You start with 6 thoughts, to be refined. Click on a thought to mark it for re-generation (in this image, 5 are to be regenerated)", 
	2: "Set the persistence and randomness! Persistence definds how much a thought stays the same after re-generation, while randomness randomizes the re-generation. \n[font_size=20]Tip: If your persistence is too low, your thoughts will quickly all become the same.[/font_size]", 
	3: "Click \"Regenerate Thoughts\" to re-generate selected thoughts. The refresh button can also be used if you want to restart from the start.", 
	4: "When you're confident, clicking \"Finish thinking!\" will let you select one final thought to say as a response. Your goal is for it to not be socially awkard.", 
	5: "If your response is socially awakard, you will get a response where the NPC speaks like they are going to leave.", 
	6: "If your response is not awkward, you will get a more positive response!", 
	7: "Good luck reaching the winning screen!!\n\n[font_size=20](as the dev, my highscore is 1 HAHA; but my brother managed to beat all of them)[/font_size]",
	8: "[font_size=20]Note that if it's stuck at \"Loading...\" for too long (it should only take a few seconds), it either means my computer is overloaded with requests from many players, or my computer is off (since i'm using my computer as a server); Contact me at @unhexhexium. on discord if it might be off (i might restart my computer and forget to re-run the server)[/font_size]"
}

var currIdx = -1 
var minIdx = -1 
var maxIdx = 8 

func displayCurr(): 
	img.texture = imgs[currIdx] 
	text.text = texts[currIdx]
	if currIdx == minIdx: 
		leftButton.hide() 
		rightButton.show() 
	elif currIdx == maxIdx: 
		leftButton.show() 
		rightButton.hide() 
	else: 
		leftButton.show() 
		rightButton.show() 



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	displayCurr() 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_left_button_pressed() -> void:
	currIdx -= 1 
	if currIdx == minIdx-1: 
		currIdx = maxIdx
	displayCurr() 


func _on_right_button_pressed() -> void:
	currIdx += 1 
	if currIdx == maxIdx+1: 
		currIdx = minIdx 
	displayCurr() 
