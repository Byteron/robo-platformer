extends Area
var speed = 20

var explosion = preload("res://source/projectile/EnergyExplosion.tscn")

func _physics_process(delta):
	var vel = -global_transform.basis.z * speed
	global_translate(vel * delta)
	if get_overlapping_bodies().size() > 0:
		print("COL")
	

func _on_EnergyBullet_body_entered(body):
	var e = explosion.instance()
	get_parent().call_deferred("add_child", e)
	e.global_transform.origin = global_transform.origin
	queue_free()

