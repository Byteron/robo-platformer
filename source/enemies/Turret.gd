extends Spatial

var target = null

onready var cannon := $turret/Cannon
onready var turret := $turret

func _physics_process(delta):
	if target:
		var new_transform = cannon.global_transform.looking_at(target.global_transform.origin + Vector3.UP, Vector3.UP)
		cannon.global_transform = cannon.global_transform.interpolate_with(new_transform, 0.05)
		cannon.scale = Vector3(1, 1, 1)

func _on_DetectionArea_body_entered(body):
	if body is Robot:
		target = body

func _on_DetectionArea_body_exited(body):
	if body is Robot:
		target = null

