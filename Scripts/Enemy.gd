extends KinematicBody

onready var model = $Model/MeshInstance
onready var invTimer = $InvencibilityTimer
onready var knockTimer = $KnockbackTimer

var life = 3
var speed = 3000
var gravity = -300

var active = false
var invencible = false
var blinkingRate = 14
var knockbackdir

var direction = Vector3(0,0,0)
var velocity = Vector3(0,0,0)
var ogPosition

var coin = preload("res://Scenes/Obj/BlockCoin.tscn")

func _ready():
	ogPosition = self.transform
	pass

func _physics_process(delta):
	#Se está em uma sala ativa
	if active:
		show()
		#Leva hit
		takeDamage()
		
		#Gravity and movement
		move(delta)
	else:
		self.transform = ogPosition
	pass

#Gravity and movement
func move(delta):
	velocity.y += gravity * delta
	velocity.x = direction.x
	velocity.z = direction.z
	velocity = move_and_slide(velocity, Vector3(0,1,0));
	pass

#Olha para o jogador
func lookAtPlayer(focus):
	look_at(focus, Vector3(0,1,0))
	self.rotation_degrees.x = 0
	self.rotation_degrees.z = 0
	pass

#Levar dano
func takeDamage():
	if invencible: #Se está em estado de invencibilidade, fica piscando
		if Engine.get_frames_drawn() % blinkingRate < blinkingRate/2:
			model.get_mesh().surface_get_material(0).albedo_color = Color(0.5,0,0,1) 
		else:
			model.get_mesh().surface_get_material(0).albedo_color = Color(1,1,1,1)
	else: #Se pode ser atacado, checa por colisão com armas
		if get_slide_count()>0:
			var object_hit = get_slide_collision(0).get_collider()
			if object_hit != null:
				if object_hit.is_in_group("Weapon") && !invencible:
					invencible = true #Liga invencibilidade
					invTimer.start() #Inicia timer para invencibilidade
					knockTimer.start() #Inicia timer para knockback
					knockbackdir = self.get_global_transform().origin - Global.player.get_global_transform().origin
					life -=1 #Subtrai vida
					#Mata se e cria moedas se chegou na vida 0
					if life == 0: 
						createCoins()
						self.queue_free()
	pass

func createCoins():
	for c in randi()%5 +3:
		c = coin.instance()
		get_node("..").add_child(c)
		c.set_global_transform(self.get_global_transform())
		c.translation += Vector3(randi()%20 - 10,5,randi()%20 - 10)
		c.rotation_degrees = Vector3(randi()%360,randi()%360,randi()%360)
		c.apply_impulse(Vector3(0,0,0),Vector3(randi()%20 - 10,30,randi()%20 - 10))
	pass

#Acabou a invencibilidade
func _on_InvencibilityTimer_timeout():
	invencible = false #Desliga invencibilidade
	model.get_mesh().surface_get_material(0).albedo_color = Color(1,1,1,1) 
	pass
