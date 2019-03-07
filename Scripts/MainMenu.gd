extends Node2D

#Buttons
onready var playButton = $Buttons/Play
onready var miniGamesButton = $Buttons/MiniGames
onready var profilesButton = $Buttons/Profiles
onready var optionsButton = $Buttons/Options
onready var exitButton = $Buttons/Exit

#Arrow
onready var arrow = $SelectPanel

#Selected Button
var buttonNum = 0

func _ready():
	playButton.connect("pressed", self, "PlayGame")
	exitButton.connect("pressed",self, "ExitGame")
	pass

func _process(delta):
	
	#Control arrow
	if Input.is_action_just_pressed("ui_leftJoy_up") || Input.is_action_just_pressed("ui_up"):
		buttonNum -= 1
		if buttonNum <= -1:
			buttonNum = 4
	if Input.is_action_just_pressed("ui_leftJoy_down") || Input.is_action_just_pressed("ui_down"):
		buttonNum += 1
		if buttonNum >= 5:
			buttonNum = 0
	
	#Move arrow
	if buttonNum == 0:
		arrow.rect_position = playButton.rect_position + Vector2(-10,-10)
	elif buttonNum == 1:
		arrow.rect_position = miniGamesButton.rect_position + Vector2(-10,-10)
	elif buttonNum == 2:
		arrow.rect_position = profilesButton.rect_position + Vector2(-10,-10)
	elif buttonNum == 3:
		arrow.rect_position = optionsButton.rect_position + Vector2(-10,-10)
	elif buttonNum == 4:
		arrow.rect_position = exitButton.rect_position + Vector2(-10,-10)
	
	#Activate selected button
	if Input.is_action_just_pressed("ui_A"):
		if buttonNum == 0:
			PlayGame()
		elif buttonNum == 4:
			ExitGame()
	
	pass

func PlayGame():
	get_tree().change_scene("res://Scenes/Menus/MapSelectMenu.tscn");
	pass

func ExitGame():
	get_tree().quit();
	pass

