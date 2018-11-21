extends KinematicBody

onready var model = $MeshInstance
var chestOpen = preload("res://Models/ChestOpen.vox")
var chestLid = preload("res://Models/ChestLid.vox")
var coin = preload("res://Scenes/Obj/BlockCoin.tscn")

var opened = false

func _ready():
	pass

func openChest():
	if !opened: 
		model.mesh =chestOpen
		createCoins()
		opened = true
	pass

func createCoins():
	for c in randi()%6 +6:
		c = coin.instance()
		get_node("..").add_child(c)
		c.set_global_transform(self.get_global_transform())
		c.translation.y += 10
		c.translation += Vector3(randi()%20 - 10,5,randi()%20 - 10)
		c.rotation_degrees = Vector3(randi()%360,randi()%360,randi()%360)
		c.apply_impulse(Vector3(0,0,0),Vector3(randi()%20 - 10,30,randi()%20 - 10))
	pass