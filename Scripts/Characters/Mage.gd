extends "res://Scripts/Characters/Enemy.gd"

var energyBall = preload("res://Scenes/Objects/Energyball.tscn")

func _ready():
	pass

func _physics_process(delta):
	#Se está em uma sala ativa
	if active:
		#Fica parado
		if knockTimer.get_time_left() == 0: #Andar normal
			direction = Vector3(0,0,0)
			direction = direction.normalized() * speed * delta
		else: #Levar Knockback
			direction = knockbackdir.normalized() * speed * delta * 3
		
		#se n tem, spawna energyball
		if !has_node("Energyball"):
			var e = energyBall.instance()
			add_child(e)
			e.set_global_transform(self.get_global_transform())
			e.translation.z -= 15
		else: #Se tem energyball
			if get_node("Energyball").charging:
				lookAtPlayer(Global.player.translation)
			
	else:
		if has_node("Energyball"):
			get_node("Energyball").queue_free()
	pass

