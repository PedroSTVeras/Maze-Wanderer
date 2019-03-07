extends Control

onready var selectPanel = $Panel

onready var resumeButton = $ResumeButton
onready var optionsButton = $OptionsButton
onready var exitButton = $ExitButton

var row = 0

func _ready():
	resumeButton.connect("pressed",self,"Resume")
	exitButton.connect("pressed",self,"Exit")
	pass

func _process(delta):
	#Pausa/despausa
	if Input.is_action_just_pressed("ui_start"):
		if self.is_visible_in_tree():
			Resume()
		else:
			self.show()
	
	#Se estiver ativo
	if self.is_visible_in_tree():
		Global.paused = true
		#Controla select panel
		if Input.is_action_just_pressed("ui_leftJoy_up") || Input.is_action_just_pressed("ui_up"):
			row -= 1
			if row <= -1:
				row = 2
		if Input.is_action_just_pressed("ui_leftJoy_down") || Input.is_action_just_pressed("ui_down"):
			row += 1
			if row >= 3:
				row = 0
		
		#Move panel
		if row == 0:
			selectPanel.rect_position = resumeButton.rect_position + Vector2(-10,-10)
		elif row == 1:
			selectPanel.rect_position = optionsButton.rect_position + Vector2(-10,-10)
		elif row == 2:
			selectPanel.rect_position = exitButton.rect_position + Vector2(-10,-10)
		
		#Activate selected button
		if Input.is_action_just_pressed("ui_A"):
			#Resume
			if (row == 0):
				Resume()
			elif (row == 2):
				Exit()
	
	pass

func Resume():
	self.hide()
	Global.paused = false

func Exit():
	Global.paused = false
	get_tree().change_scene("res://Scenes/Menus/Main.tscn");
