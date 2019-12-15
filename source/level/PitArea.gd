extends Area



func _on_PitArea_body_entered(body):
	if body is Robot:
		body.respawn()
