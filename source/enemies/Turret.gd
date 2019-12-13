extends Spatial

var target = null

func _physics_process(delta):#
	if target:
		$TargetRay.look_at(target.transform.origin,Vector3.UP)
		$TargetRay.rotate_y(90)
		$turret/Cannon.rotation=lerp($turret/Cannon.rotation, $TargetRay.rotation, 0.01)
#		$turret/Cannon.look_at(target.transform.origin,Vector3.UP)
		
func _on_DetectionArea_body_entered(body):
	if body is Robot:
		target = body

func _on_DetectionArea_body_exited(body):
	if body is Robot:
		target = null
		
