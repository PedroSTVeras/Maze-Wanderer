extends Node

#IDs de tile
var inicioId = 1
var finalId = 0
var normalId = 6
var IDvazio = -1

var roomMap = preload("res://Scenes/Tiles/Roommap.tscn")
var room1 = preload("res://Scenes/Rooms/Room - v1.tscn")
var player_type = preload("res://Scenes/Characters/Player.tscn")

onready var main = get_node("/root/Main")
var player

var mapPos #Matrix contendo as salas do mapa
var mapNode #Nodo que guarda todos os tiles do mapa
var mapSize = 8 #Tamanho do mapa é 8x8
var distance = 4 #Distancia entre sala inicio e sala fim

var iniPos #Posição da sala inicial
var finPos #Posição da sala final

var roomList = [] #As salas no jogo 3D
var roomListIndex =0 #Index da lista de rooms

var showRooms = false

func readyMap():
	#Cria Player
	player = player_type.instance()
	#Cria novo mapa
	mapPos = []
	generate_map(distance)
	#Add player
	add_child(Global.player)
	pass

#Reseta o mapa e cria um novo (chamado no ready() da Global)
func reset():
	mapPos = []
	generate_map(distance)
	#Add player
	add_child(Global.player)

#Gera sala inicial e final (chamado no reset() da Global)
func generate_map(dist):
	#Criar matrix de posição dos mapas (todos vazios por default)
	for x in range(mapSize):
		mapPos.append([])
		for y in range(mapSize):
			mapPos[x].append(IDvazio)
	
	#Criar início
	randomize() 
	var posX
	var posY
	var a = randi()%2
	if a == 0:
		posX = randi()%2+1 
	else:
		posX = randi()%2+5 
	var aa = randi()%2
	if aa == 0:
		posY = randi()%2+1 
	else:
		posY = randi()%2+5
	mapPos[posX][posY] = inicioId #marca como preenchido o local do tile na matriz
	iniPos = Vector2(posX,posY)
	
	#Criar final
	while(mapPos[posX][posY] != IDvazio): #Gerar nova posição se a atual estiver ocupada
		if a == 0:
			posX = posX + dist + randi()%2
		else:
			posX = posX - dist + randi()%2
		if aa == 0:
			posY = posY + dist + randi()%2
		else:
			posY = posY - dist + randi()%2
		if posX > mapSize - 1:
			posX = mapSize - 1
		if posX < 0: 
			posX = 0
		if posY > mapSize - 1:
			posY = mapSize - 1 
		if posY < 0:
			posY = 0
	mapPos[posX][posY] = finalId
	finPos = Vector2(posX,posY)
	
	#Criar tiles normal
	find_path()
	pass

#Encontra o caminho entre as salas de inicio e fim (chamado no generate_map da Global)
func find_path():
	#Pega posição da sala inicial e seta como a atual
	var tileX = iniPos.x
	var tileY = iniPos.y
	#Pega diferença de distancia entre sala atual e final
	var difX = finPos.x - tileX
	var difY = finPos.y - tileY
	
	#Gera posição perto da sala atual
	while (difX != 0 || difY != 0):
		var r = randi()%2 #Escolhe se vai mexer na horizontal ou vertical
		if r == 0:
			if difX > 0: #Escolha se vai para esq ou dir
				tileX += 1
			else:
				tileX -= 1
		else:
			if difY > 0: #Escolha se vai para cima ou para baixo
				tileY += 1
			else:
				tileY -= 1
		
		#Coloca sala na posição gerada se estiver vazia
		if mapPos[tileX][tileY] == IDvazio:
			mapPos[tileX][tileY] = normalId
		#Pega diferença de distancia entre sala atual e final
		difX = finPos.x - tileX
		difY = finPos.y - tileY
	pass

#Mostra salas descobertas (chamado toda vez que uma nova sala é descoberta, no script da Sala)
func enableRoom(menu,pos):
	for N in menu.get_children():#Pega salas no menu
		if N.get_child_count() > 0:
			if N.pos == pos:
				N.show()
	pass

#Desenha o mapa usando a matrix mapPos (chamado no ready() do MenuIngame)
func draw_map(menu):
	#print(mapPos)
	for x in range(mapSize):
		for y in range(mapSize):
			if mapPos[x][y] != IDvazio:
				var r = roomMap.instance() #Cria sprite da sala
				menu.add_child(r) 
				r.position = Vector2(x * 120 + -420, y * 80 + -280) #Posiciona no lugar certo
				r.setMapPos(x, y) #Seta posição no tile
				r.generateDoors() #Gera portas de acordo com as salas ao lado
				r.id = mapPos[x][y]
	pass

#Coloca salas no mundo baseada no mapa (chamdo no ready() do MenuIngame)
func placeRoom(menu, main): 
	roomList.resize(64)
	for N in menu.get_children():#Pega salas no menu
		if N.get_child_count() > 0:
			var r = room1.instance()
			roomList[roomListIndex] = r
			roomListIndex+=1
			r.id = N.id
			main.add_child(r)
			r.changePos(N.pos)
			#Coloca portas
			for D in N.get_children():
				if D.get_child_count() > 0:
					r.makeDoors(D)
			#r.removeDoors()
	roomList.resize(roomListIndex)
	pass

#Arruma as salas 3D de acordo com o minimapa 2D (chamado no process() do MenuIngame)
func correctRooms(main, menu):
	for N in menu.get_children(): #Sprites das salas
		if N.get_child_count() > 0:
			for R in main.get_children(): #Salas no jogo 3D
				if R.get_child_count() > 0:
					if N.get_name() == R.get_name(): #Se tiver o mesmo nome
						if N.pos != R.pos: #Se as posições forem diferentes
							#print(N.get_name(), " - ", R.get_name(), " - ", N.pos, " - ", R.pos)
							N.set_name(str("Room ", N.pos.x, "-", N.pos.y))
							R.set_name(str("Room ", N.pos.x, "-", N.pos.y))
							R.changePos(N.pos)
	pass

#Liga e desliga o mesh das salas (chamado no process() do MenuIngame)
func activateRooms():
	for r in range (roomListIndex):
#		#Sala que o jogador está presente
#		if roomList[r].pos == Global.player.lastPos:
#			roomList[r].activate(true,true,true)
#		#Salas vizinhas a do jogador
#		elif roomList[r].pos == (Global.player.lastPos + Vector2(-1,0)) || roomList[r].pos == (Global.player.lastPos + Vector2(1,0)) || roomList[r].pos == (Global.player.lastPos + Vector2(0,-1)) || roomList[r].pos == (Global.player.lastPos + Vector2(0,1)):
#			roomList[r].activate(showRooms,false,false) 
#		#Salas restantes no jogo
#		else:
#			roomList[r].activate(false,false,false)
		if roomList[r].pos == (Global.player.lastPos + Vector2(-1,0)) || roomList[r].pos == (Global.player.lastPos + Vector2(1,0)) || roomList[r].pos == (Global.player.lastPos + Vector2(0,-1)) || roomList[r].pos == (Global.player.lastPos + Vector2(0,1)):
			roomList[r].activate(showRooms,false,false) 
		elif roomList[r].pos != Global.player.lastPos:
			roomList[r].activate(false,false,false)
	if Input.is_action_just_pressed("ui_page_down"):
		showRooms = !showRooms
	pass

