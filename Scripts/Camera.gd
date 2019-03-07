extends Camera

var speed = 5

func _ready():
	pass

func moveCamera():
	if Input.is_action_pressed("ui_rightJoy_right"):
		self.translation.x += speed
	if Input.is_action_pressed("ui_rightJoy_left"):
		self.translation.x -= speed
	if Input.is_action_pressed("ui_rightJoy_up"):
		self.translation.z -= speed
	if Input.is_action_pressed("ui_rightJoy_down"):
		self.translation.z += speed
	pass

func _process(delta):
	if !Global.paused:
		moveCamera()
	pass
