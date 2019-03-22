extends Spatial

onready var p1 = $Parede1
onready var p2 = $Parede2
onready var p3 = $Parede3
onready var p4 = $Parede4
onready var teto = $Teto
onready var camera = $Camera

onready var menu = get_node("../MapMenu/menu")

var cameraAux
var cameraMoving = false

var itens
var id
var pos
var found = false #Se a sala foi descoberta pelo player ou não

func _ready():
	teto.queue_free()
	activate(false,false,false)
	
	if id == 1:
		itens = load("res://Scenes/RoomItens/RoomItens0.tscn")
	else:
		var a = randi()% 4 + 1
		itens = load("res://Scenes/RoomItens/RoomItens" + str(a) + ".tscn")
	var i = itens.instance()
	add_child(i)
	
	pass

func _process(delta):
	#Se está fazendo a transição de cenas
#	if cameraMoving:
#		Global.player.camera.translation += cameraAux/85 #Move a camera do player em direção a camera da cena
#		Global.player.canMove = false #Jogador n pode se mover
#
#		#Checa distancia entre as duas cameras
#		var dist = Global.player.camera.get_global_transform().origin.distance_to(camera.get_global_transform().origin)
#		if (dist < 5): #Se a distancia for pequena, chegou na nova sala
#			Global.player.camera.translation = Global.player.ogCamTrans #retorna a camera do player para a pos que pertencia
#			Global.player.camera = $Camera #seta a camera do player como a da cena atual
#			Global.player.camera.current = true #Seta ela como camera atual
#			Global.player.canMove = true #Deixa player se mexer
#			cameraMoving = false #Camera para de se mexer
#			activate(true,true,true) #Liga toda a sala
	pass

#Ativa ou desativa mesh das salas (melhora fps)
func activate(salaOn, itensOn, enemiesOn):
	for N in self.get_children(): #Pega todos os filhos (partes da sala)
		if N.get_child_count() > 0:
			
			#Liga e desligao chão e as paredes (visualmente)
			if salaOn:
				N.show()
				#Liga filhos (exceto bordas)
				for r in N.get_children(): 
					if (r.get_name() != "Borda"):
						r.show()
			else:
				N.hide()
				#Desliga filhos (exceto bordas)
				for r in N.get_children(): 
					if (r.get_name() != "Borda"):
						r.hide()
			
			#Ativa e desativa itens na sala
			if N.is_in_group("Itens"):
				if itensOn:
					N.show()
				else:
					N.hide()
				#Ativa e desativa inimigos na sala
				for r in N.get_children(): 
					if r.is_in_group("Enemy"):
						r.active = enemiesOn
	pass

#Muda posição
func changePos(p):
	pos = p
	set_translation(Vector3(pos.x * 296, 0, pos.y * 215)) #Posiciona corretamente

#Crias as portas das salas baseadas nas portas dos tiles no mapa
func makeDoors(d):
	if d.get_name() == "Door1":
		p1.get_node("ParedeAux").queue_free()
		p1.get_node("Borda").show()
	
	if d.get_name() == "Door2":
		p2.get_node("ParedeAux").queue_free()
		p2.get_node("Borda").show()
	
	if d.get_name() == "Door3":
		p3.get_node("ParedeAux").queue_free()
		p3.get_node("Borda").show()
	
	if d.get_name() == "Door4":
		p4.get_node("ParedeAux").queue_free()
		p4.get_node("Borda").show()
	
	#Arruma nome, pra n ficar sujo
	self.set_name(str("Room ", pos.x, "-", pos.y))

func removeDoors():
	if !p1.get_node("Borda").is_visible_in_tree():
		p1.get_node("Borda").queue_free()
	if !p2.get_node("Borda").is_visible_in_tree():
		p2.get_node("Borda").queue_free()
	if !p3.get_node("Borda").is_visible_in_tree():
		p3.get_node("Borda").queue_free()
	if !p4.get_node("Borda").is_visible_in_tree():
		p4.get_node("Borda").queue_free()
	pass

#Se player colidiu, remove teto e ativa sala no minimapa
func _on_Area_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.get_name() == "Player":
		#Se for a primeira sala, seta a camera inicial 
		if body.lastPos == Vector2(0,0):
			activate(true,true,true)#Liga a sala, itens e inimgos
			body.camera = $Camera #Camera do jogador aponta para a camera da primeira cena
			body.camera.current = true #Seta a camera como a atual
			body.ogCamTrans = camera.translation #e salva pos inicial para retornar ela mais tarde
		else: #Mover camera para a proxima sala 
			cameraMoving = true #começa a mover a camera
			var a = camera.get_global_transform().origin - body.camera.get_global_transform().origin #Pega a diferença de posição entre a camera do player e da cena
			cameraAux = Vector3(a.z * -1,0,a.x) #Arruma o x e z e manda para cameraAux
			activate(true,true,false) #Liga a sala e itens, mas não os inimgos
		body.lastPos = pos #Seta a posição do player a mesma da sala
		
		#Entrou na sala pela primeira vez, ativa ela no minimapa
		if found == false:
#			Global.enableRoom(menu,pos)
			found = true
	pass

func _on_Area_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.get_name() == "Player":
		activate(false,false,false)
	pass 
