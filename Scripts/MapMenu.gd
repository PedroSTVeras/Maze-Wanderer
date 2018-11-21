extends Node2D

onready var highlight = $highlight
onready var menu = $menu
onready var heart = $Heart

var hlPos
var aux = 0

func _ready():
	hlPos = Vector2(0,0)

#Checa se pode pegar a sala e passa para o highlight
func checkAllRooms(menu, x, y): 
	#Checa todas as salas
	for N in menu.get_children():
		if N.get_child_count() > 0:
			#Se for a selecionada pelo Highlight e não é a sala incial ou fim
			#checa se  a posição é a mesma, se o id pode mexer (n é inicio/fim),
			#se está visível (foi explorada) e se o jogadro n está na sala
			if N.pos == Vector2(x, y) && Global.mapPos[x][y] == Global.normalId && N.is_visible() && Global.player.lastPos != N.pos: 
				#print ("Pega sala: ",N.get_name())
				menu.remove_child(N) #Tira sala do menu   
				highlight.add_child(N) #e coloca no highlight
				N.position = Vector2(0,0) #posiciona corretamente
				N.show_behind_parent = true
				highlight.self_modulate = Color(1,0,0)
				Global.mapPos[x][y] = Global.IDvazio #Atualiza matriz

#checa se pode soltar a sala e passa para o menu/mapa
func setRoom(highlight, menu, hlPos):
	var N = highlight.get_child(0) 
	highlight.remove_child(highlight.get_child(0)) #Tira sala do highlight   
	menu.add_child(N) #e coloca no menu
	N.pos = Vector2(hlPos.x, hlPos.y) #Arruma pos na sala
	N.position = Vector2(hlPos.x * 120 + -420, hlPos.y * 80 + -280) #posiciona corretamente
	N.show_behind_parent = false
	highlight.self_modulate = Color(1,1,1)
	Global.mapPos[hlPos.x][hlPos.y] = Global.normalId #Atualiza matriz

#Movimentação do highlight
func move_highlight():
	#Move highlight
	if Input.is_action_just_pressed("ui_left") && highlight.position.x > 60:
		highlight.position.x -= 120
	if Input.is_action_just_pressed("ui_right") && highlight.position.x < 900:
		highlight.position.x += 120
	if Input.is_action_just_pressed("ui_up") && highlight.position.y > 40:
		highlight.position.y -= 80
	if Input.is_action_just_pressed("ui_down") && highlight.position.y < 600:
		highlight.position.y += 80
		
	hlPos.x = (highlight.position.x-60)/120
	hlPos.y = (highlight.position.y-40)/80
		
	if Input.is_action_just_pressed("ui_select"):
		#Se n tem tile, pega um
		if highlight.get_child_count() == 0: 
			checkAllRooms(menu, hlPos.x, hlPos.y)
		#Se tem tile e posição está livre, solta
		elif highlight.get_child_count() == 1 && Global.mapPos[hlPos.x][hlPos.y] == Global.IDvazio: 
			setRoom(highlight,menu,hlPos)
	pass

func _process(delta):
	#Arrumar pos do player no mapa
	heart.position = Vector2(Global.player.lastPos.x * 120 + 60,Global.player.lastPos.y * 80 +40)  
	
	#sair
	if Input.is_action_just_pressed("ui_quit"):
		get_tree().quit()
	
	#Jogo pausado: pode mover hl
	if get_tree().paused: 
		move_highlight()
	pass