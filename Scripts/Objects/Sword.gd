extends KinematicBody

func _ready():
	pass

func _physics_process(delta):
	self.rotate_y(0.3)

func _on_Timer_timeout():
#	Global.player.canMove = true
	self.queue_free()
	pass # replace with function body
