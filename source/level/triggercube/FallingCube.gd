extends "res://source/level/triggercube/TriggerCube.gd"

onready var head = $TriggerCube/Head
onready var shape = $CollisionShape

var falling = false
var falling_speed = 2.0

func _physics_process(delta):
	if falling:
		move_and_slide(Vector3.DOWN * falling_speed)

func trigger():
	if not triggered:
		.trigger()
		$FallTimer.start()
		$HeadTween.interpolate_property(head, "translation", head.translation, head.translation + Vector3(0,-0.2,0),0.2,Tween.TRANS_SINE,Tween.EASE_OUT)
		$HeadTween.interpolate_property(shape, "translation", shape.translation, shape.translation + Vector3(0,-0.2,0),0.2,Tween.TRANS_SINE,Tween.EASE_OUT)
		$HeadTween.start()


func _on_FallTimer_timeout():
	falling = true
