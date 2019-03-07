extends Control

onready var panel = $Panel
onready var pName = $Name

var modelID
var colorID

var viewport = null
var viewport_sprite = null

var models = []

func _ready():
	#colorID = Global.players[num].colorID
	#Load Models
	models.resize(3)
	models[0] = load("res://Models/Characthers/Knight.vox")
	models[1] = load("res://Models/Characthers/RedSkull.vox")
	models[2] = load("res://Models/Characthers/Hero.vox")
	
	#Set Profile Name
	pName.set_text("Player "+str(colorID))
	
	#Set color
	if colorID == 1:
		panel.modulate = Color("69504dbb")
	elif colorID == 2:
		panel.modulate = Color("694dbb6e")
	elif colorID == 3:
		panel.modulate = Color("69bbb14d")
	elif colorID == 4:
		panel.modulate = Color("69bb554d")
	elif colorID == 5:
		panel.modulate = Color("69bb4db6")
	elif colorID == 6:
		panel.modulate = Color("691fb9b2")
	elif colorID == 7:
		panel.modulate = Color("69ffffff")
	elif colorID == 8:
		panel.modulate = Color("69000000")
	panel.modulate.a = 1
	
	#Change mesh
	var mesh = $Viewport/CharacterShots/MeshInstance
	mesh.mesh = models[modelID]#Global.players[num].modelID]
	
	#Viewport
	viewport = get_node("Viewport")
	viewport_sprite = get_node("Sprite")
	
	#Get texture
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	viewport_sprite.texture = viewport.get_texture()
	viewport_sprite.scale = Vector2(3.5,3.5)
	
	pass




