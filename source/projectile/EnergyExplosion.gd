extends Spatial

func _ready():
	explode()

func explode():
	$AnimationPlayer.play("explode")
	yield($AnimationPlayer,"animation_finished")
	queue_free()
