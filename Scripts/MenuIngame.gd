extends Panel

onready var hl = $MapMenu/highlight
onready var menu = $MapMenu/menu

var main

func _ready():
	#Chama função de desenhar tiles no mapa
	Global.draw_map(menu)
	#Coloca salas no mundo baseada no mapa
	Global.placeRoom(menu, self)
	pass

func _process(delta):
	Global.activateRooms()
	#Jogo pausado
	if Input.is_action_just_pressed("ui_pause"):
		if !self.visible: #pausa
			get_tree().paused = true
			self.show()
		elif self.visible && hl.get_child_count() == 0: #despausa
			get_tree().paused = false
			self.hide()
			Global.correctRooms(self,menu)