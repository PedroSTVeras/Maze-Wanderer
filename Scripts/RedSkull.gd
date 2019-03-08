extends "res://Scripts/Enemy.gd"

#onready var model = $Model/MeshInstance

var chasing = false

var armDown = preload("res://Models/Characthers/RedSkull.vox")

func _ready():
	pass

func _physics_process(delta):
	#Se está em uma sala ativa
	if active:
		#Se player entra no alcance da caveira
		var dist = Global.player.get_global_transform().origin.distance_to(self.get_global_transform().origin)
		if dist < 100:
			chasing = true
		
		#Chasing: Olha para o jogador e vai atras dele
		if chasing:
			lookAtPlayer(Global.player.get_global_transform().origin)
			pathFinding(delta)
			#model.mesh = armUp
		else:
			direction = Vector3(0,0,0)
			direction = direction.normalized() * speed * delta
			#model.mesh = armDown
			
	else:
		chasing = false
		life = 3
	pass

#Anda na direção do jogador (usar A* star)
func pathFinding(delta):
	#Anda na direção do jogador (usar A* star)
	if knockTimer.get_time_left() == 0: #Andar normal
		direction = Global.player.get_global_transform().origin - self.get_global_transform().origin
		direction = direction.normalized() * speed * delta
	else: #Levar Knockback
		direction = knockbackdir.normalized() * speed * delta * 4
	pass
