extends Spatial

var target = null

onready var cannon := $turret/Cannon
onready var turret := $turret
onready var bullet_pos := $turret/Cannon/BulletPos

var bullet_scene = preload("res://source/projectile/EnergyBullet.tscn")


func _physics_process(delta):
	if target:
		var new_transform = cannon.global_transform.looking_at(target.global_transform.origin + Vector3.UP, Vector3.UP)
		cannon.global_transform = cannon.global_transform.interpolate_with(new_transform, 0.05)
		cannon.scale = Vector3(1, 1, 1)
	if Input.is_action_just_pressed("ui_accept"):
		shoot()
func _on_DetectionArea_body_entered(body):
	if body is Robot:
		target = body

func _on_DetectionArea_body_exited(body):
	if body is Robot:
		target = null

func shoot():
	var new_bullet = bullet_scene.instance()
	get_parent().call_deferred("add_child", new_bullet)
	yield(get_tree(), "idle_frame")
#	new_bullet.global_transform.origin = bullet_pos.global_transform.origin
	new_bullet.global_transform = cannon.global_transform
