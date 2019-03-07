extends Panel

onready var selectPanel = $Panel
onready var selectPanel2 = $NextPanel
onready var playButton = $PlayButton

var column = 0
var row = 0

func _ready():
	playButton.connect("pressed",self,"NextScreen")
	pass

func _process(delta):
	
	#Control panel
	if Input.is_action_just_pressed("ui_leftJoy_right") || Input.is_action_just_pressed("ui_right"):
		column += 1
		if column >= 4:
			column = 0
	if Input.is_action_just_pressed("ui_leftJoy_left") || Input.is_action_just_pressed("ui_left"):
		column -= 1
		if column <= -1:
			column = 3
	if Input.is_action_just_pressed("ui_leftJoy_up") || Input.is_action_just_pressed("ui_up"):
		row -= 2
		if row <= -1:
			row = 2
	if Input.is_action_just_pressed("ui_leftJoy_down") || Input.is_action_just_pressed("ui_down"):
		row += 2
		if row >= 3:
			row = 0
	
	#Move arrow
	if get_node("PlayerButtons/PlayerButton"+str(1+column+(row*4))) != null:
		selectPanel.rect_position = get_node("PlayerButtons/PlayerButton"+str(1+column+(row*4))).rect_position + Vector2(-10,-10)
	if row == 2:
		selectPanel.hide()
		selectPanel2.show()
	else:
		selectPanel.show()
		selectPanel2.hide()
	
	#Activate selected button
	if Input.is_action_just_pressed("ui_A"):
		#Change type (Player/CPU)
		if (row !=2):
			get_node("PlayerButtons/PlayerButton"+str(1+column+(row*4))).ChangeType()
		#Go to next screen
		else:
			NextScreen()
	
	#Change character
	if Input.is_action_just_pressed("ui_R2"):
		if (row !=2):
			get_node("PlayerButtons/PlayerButton"+str(1+column+(row*4))).charNumber += 1
			get_node("PlayerButtons/PlayerButton"+str(1+column+(row*4))).ChangeCharacter()
	if Input.is_action_just_pressed("ui_L2"):
		if (row !=2):
			get_node("PlayerButtons/PlayerButton"+str(1+column+(row*4))).charNumber -= 1
			get_node("PlayerButtons/PlayerButton"+str(1+column+(row*4))).ChangeCharacter()
	
	#Go back
	if Input.is_action_just_pressed("ui_B"):
		PrevScreen()
	
	pass

func NextScreen():
	get_tree().change_scene("res://Scenes/Menus/RulesSelectMenu.tscn");

func PrevScreen():
	get_tree().change_scene("res://Scenes/Menus/MapSelectMenu.tscn");
