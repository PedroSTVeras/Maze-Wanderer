extends KinematicBody

onready var model = $MeshInstance
onready var particle = $Particles
onready var cs = $CollisionShape

var speed = 5000
var direction = Vector3(0,0,0)
var charging = true

func _process(delta):
	direction = direction.normalized() * speed * delta
	direction = move_and_slide(direction, Vector3(0,1,0));
	
	if get_slide_count()>0:
		var object_hit = get_slide_collision(0).get_collider()
		if object_hit != null:
			if object_hit.is_in_group("Parede"):
				queue_free()
			if object_hit.is_in_group("Weapon"):
				queue_free()
	pass

func _on_Timer_timeout():
	if charging:
		particle.queue_free()
		model.show()  
		direction = Global.player.get_global_transform().origin - self.get_global_transform().origin
		cs.set_disabled(false)
		charging = false
	else:
		queue_free()
	pass 
