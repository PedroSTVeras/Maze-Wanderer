extends Panel

onready var selectPanel = $Panel
onready var selectPanel2 = $NextPanel
onready var playButton = $PlayButton

var row = 0

func _ready():
	playButton.connect("pressed",self,"NextScreen")
	pass

func _process(delta):
	
	#Control panel
	if Input.is_action_just_pressed("ui_leftJoy_up") || Input.is_action_just_pressed("ui_up"):
		row -= 1
		if row <= -1:
			row = 5
	if Input.is_action_just_pressed("ui_leftJoy_down") || Input.is_action_just_pressed("ui_down"):
		row += 1
		if row >= 6:
			row = 0
	
	#Move arrow
	if get_node("AllStats/Stats"+str(1+row)) != null:
		selectPanel.rect_position = get_node("AllStats/Stats"+str(1+row)).rect_position + Vector2(-10,-10)
	#selectPanel.rect_position.y = 80 + row * 80;
	if row == 5:
		selectPanel.hide()
		selectPanel2.show()
	else:
		selectPanel.show()
		selectPanel2.hide()
	
	#Activate selected button
	if Input.is_action_just_pressed("ui_A"):
		if row == 5:
			NextScreen() 
	
	if Input.is_action_just_pressed("ui_B"):
		PrevScreen()
	
	pass

#Play game (load map/create character)
func NextScreen():
	get_tree().change_scene("res://Scenes/Map/TestMap.tscn");

func PrevScreen():
	get_tree().change_scene("res://Scenes/Menus/PlayerSelectMenu.tscn");
