extends KinematicBody

var life = 5
var speed = 5000
var gravity = -300
var coins = 0

var direction = Vector3()
var velocity = Vector3()
var lastPos = Vector2(0,0)#pos da ultima sala em q esteve

var canMove = true
var invencible = false
var blinkingRate = 14
var knockbackdir

var ogCamTrans
onready var camera 
onready var rc = $RayCast
onready var model = $Knight
onready var cs = $CollisionShape
onready var fps_label = $HealthBar/fps_label
onready var coin_label = $HealthBar/coin_label
onready var health_bar = $HealthBar
onready var knockTimer = $KnockbackTimer

var sword = preload("res://Scenes/Sword.tscn")
var swordDir = 0

func _ready():
	rc.cast_to = Vector3(5, 0, 0)
	self.translate(Vector3(Global.iniPos.x * 296, 30, Global.iniPos.y * 215))
	pass

func moveCamera():
	if Input.is_key_pressed(KEY_I):
		camera.translation.x += 1
	if Input.is_key_pressed(KEY_K):
		camera.translation.x -= 1
	if Input.is_key_pressed(KEY_J):
		camera.translation.z -= 1
	if Input.is_key_pressed(KEY_L):
		camera.translation.z += 1
	pass

func movement(delta):
	#moveCamera()
	
	#Se pode mover
	if canMove:
		#Move
		if Input.is_action_pressed("ui_left"):
			direction.x -= 1
			swordDir = 180
			model.rotation_degrees.y = 270
		if Input.is_action_pressed("ui_right"):
			direction.x += 1
			swordDir = 0
			model.rotation_degrees.y = 90
		if Input.is_action_pressed("ui_up"):
			direction.z -= 1
			swordDir = 90
			model.rotation_degrees.y = 180
		if Input.is_action_pressed("ui_down"):
			direction.z += 1
			swordDir = 270
			model.rotation_degrees.y = 0
		
		#Player rotation
		if direction.z == 1 && direction.x == 1:
			model.rotation_degrees.y = 45
			swordDir = 315
		if direction.z == -1 && direction.x == 1:
			model.rotation_degrees.y = 135
			swordDir = 45
		if direction.z == -1 && direction.x == -1:
			model.rotation_degrees.y = 225
			swordDir = 135
		if direction.z == 1 && direction.x == -1:
			model.rotation_degrees.y = 315
			swordDir = 225
		cs.rotation_degrees.y = model.rotation_degrees.y
		
		#Ataque com espada
		if Input.is_action_just_pressed("ui_attack"):
			var s = sword.instance()
			add_child(s)
			s.rotate_y(deg2rad(swordDir))
			canMove = false
	
	#Leva hit
	if get_slide_count()>0:
		var object_hit = get_slide_collision(0).get_collider()
		if object_hit != null:
			if object_hit.is_in_group("Enemy") && !invencible:
				takeDamage(object_hit)
			if object_hit.is_in_group("Shot"):
				object_hit.queue_free()
			if object_hit.is_in_group("Coin"):
				object_hit.queue_free()
				coins += 1
			if object_hit.is_in_group("Chest"):
				object_hit.openChest()
	
	#Normalizar (andar na mesma velocidade na diagonal)
	if knockTimer.get_time_left() == 0: #Andar normal
		direction = direction.normalized()
		direction = direction * speed * delta
	else: #Knockback
		direction = knockbackdir.normalized() * speed * delta * 3
	velocity.y += gravity * delta
	velocity.x = direction.x
	velocity.z = direction.z
	velocity = move_and_slide(velocity, Vector3(0,1,0));
	
	#Efeito de piscar
	if invencible:
		if Engine.get_frames_drawn() % blinkingRate < blinkingRate/2:
			model.get_mesh().surface_get_material(0).albedo_color = Color(0.5,0,0,1) 
		else:
			model.get_mesh().surface_get_material(0).albedo_color = Color(1,1,1,1)
		
	pass

func takeDamage(object_hit):
	invencible = true #Liga envincibilidade
	$InvencibilityTimer.start() #Inicia timer para invencibilidade
	knockTimer.start() #Inicia timer para knockback
	knockbackdir = self.get_global_transform().origin - object_hit.get_global_transform().origin
	
	life -=1
	health_bar.set_texture(load("res://Sprites/Health/" + str(life) + "hp.png"))
	pass

func _on_InvencibilityTimer_timeout():
	invencible = false #Desliga invencibilidade
	model.get_mesh().surface_get_material(0).albedo_color = Color(1,1,1,1) #arruma cor depois do final de piscar 
	pass

func _physics_process(delta):
	direction = Vector3(0,0,0)
	
	#Mostra fps
	fps_label.set_text(str(Engine.get_frames_per_second()))
	if Input.is_action_just_pressed("ui_page_up"):
		if !fps_label.is_visible():
			fps_label.show()
		else:
			fps_label.hide()
	
	#Mostra coins
	coin_label.set_text(str(coins))
	
#	if Input.is_action_just_pressed("ui_restart"):
#		get_node("/root/Main").remove_child(Global.player)
#		print(1)
#		Global.reset()
#		print(2)
#		get_tree().reload_current_scene()
#		print(3)
	
	#Raycast
	if direction.z != 0 || direction.x != 0:
		rc.cast_to = Vector3(direction.x * 5, direction.z * 5, 0)
	
	#Movimentação
	movement(delta)
