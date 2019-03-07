extends Button

#Buttons
onready var playerName = $PlayerName
onready var CPUName = $CPUName
onready var number = $PlayerName/NumberPanel/Number
onready var typeButton = $TypeButton

var viewport = null
var viewport_sprite = null

var mesh
var models = []
var type = 0
var charNumber = 0

export(int) var numID

func _ready():
	viewport = get_node("Viewport")
	viewport_sprite = get_node("Sprite")
	
	#Load Models
	models.resize(3)
	models[0] = load("res://Models/Characthers/Knight.vox")
	models[1] = load("res://Models/Characthers/RedSkull.vox")
	models[2] = load("res://Models/Characthers/Hero.vox")
	
	#Set player numbers and buttons
	number.set_text(str(numID))
	self.connect("pressed", self, "ChangeCharacter")
	typeButton.connect("pressed",self, "ChangeType")
	
	#Set character and type
	#type = Global.chosenPlayers[numID-1]
	type -= 1
	ChangeCharacter()
	ChangeType()
	
	pass

func _process(delta):
	Global.chosenTypePlayers[numID-1] = type
	Global.chosenModelPlayers[numID-1] = charNumber
	pass

#Change model
func ChangeCharacter():
	if type != 0:
		#Fix char number
		if charNumber <= -1:
			charNumber = models.size()-1
			charNumber = models.size()-1
		elif charNumber >= models.size():
			charNumber = 0
			charNumber = 0
		
		#Change mesh
		var mesh = $Viewport/CharacterShots/MeshInstance
		mesh.mesh = models[charNumber]
		
		#Get texture
		viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		viewport_sprite.texture = viewport.get_texture()
		viewport_sprite.scale = Vector2(5.75,5.75)

#Change type: No player, player, CPU
func ChangeType():
	type += 1;
	
	#Go back to 0
	if (type >= 3 || type <= -1):
		type = 0
	
	#No character
	if (type == 0):
		playerName.hide()
		CPUName.hide()
		viewport_sprite.hide()
	#Player
	elif (type == 1):
		playerName.show()
		CPUName.hide()
		viewport_sprite.show()
	#CPU
	elif (type == 2):
		playerName.hide()
		CPUName.show()
		viewport_sprite.show()
	pass