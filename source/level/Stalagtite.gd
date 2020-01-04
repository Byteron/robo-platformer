extends Spatial
var falling = false

func fall():
	if not falling:
		$AnimationPlayer.play("fall")
		falling = true


func _on_Area_body_entered(body):
	pass # Replace with function body.
