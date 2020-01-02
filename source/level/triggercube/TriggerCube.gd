extends KinematicBody

var triggered = false

func _on_Area_body_entered(body):
	if body is Robot:
		trigger()

func trigger():
	triggered = true
