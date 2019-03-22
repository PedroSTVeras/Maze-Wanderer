extends Sprite

onready var door1 = $Door1
onready var door2 = $Door2
onready var door3 = $Door3
onready var door4 = $Door4

var pos
var id

func _ready():
	self.hide()
	pass 

func _process(delta):
	pass

#Seta qual a posição do tile na matrix dos tiles
func setMapPos_(x, y):
	pos = Vector2(x,y)
#	#Troca sprites (sala inicial e final) #print ( Global.mapPos[x][y])
#	if Global.mapPos[x][y] == Global.inicioId:
#		texture = load("res://Sprites/Rooms map/iniroommap.png")
#		self.show()
#	elif Global.mapPos[x][y] == Global.finalId:
#		texture = load("res://Sprites/Rooms map/finalroommap.png")
#		self.show()
	pass

#gera portas de acordo com as salas ao lado
func generateDoors():
#	if Global.mapPos[pos.x - 1][pos.y] == -1:
#		 door2.free()
#	if Global.mapPos[pos.x][pos.y - 1] == -1:
#		 door3.free()
#	if (pos.y + 1) < 8:
#		if Global.mapPos[pos.x][pos.y + 1] == -1:
#			 door1.free()
#	else:
#		door1.free()
	
#	if (pos.x +1) < 8:
#		if Global.mapPos[pos.x + 1][pos.y] == -1:
#			 door4.free()
#	else: 
#		door4.free()
	self.set_name(str("Room ", pos.x, "-", pos.y)) #Arruma nome, pra n ficar sujo