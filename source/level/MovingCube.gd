extends KinematicBody

export (bool) var backwards = false
export (float) var distance = 5.0
export (float) var speed = 4.0

onready var helper = $Helper
onready var move_tween = $MoveTween

var moved = 0.0
var dir = Vector3.FORWARD
onready var start_pos = translation
onready var target_pos = Vector3()
var player_inside = false

func _ready():
	helper.hide()
	dir = dir.rotated(Vector3.UP,rotation.y)
	target_pos = translation + dir*distance
	$movingCube/Cube.set("material/2", $movingCube/Cube.get("material/2").duplicate())

func move_forward():
	var time = distance/speed
	move_tween.interpolate_property(self,"translation",translation,target_pos , time,Tween.TRANS_SINE,Tween.EASE_IN_OUT )
	move_tween.start()

func move_back():
	var time = abs((translation - start_pos).length()) / speed
	move_tween.interpolate_property(self,"translation",translation, start_pos,time,Tween.TRANS_SINE,Tween.EASE_IN_OUT )
	move_tween.start()


func _on_Area_body_entered(body):
	if body is Robot:
		player_inside = true
		move_forward()
		$AnimationPlayer.play("start_glow")


func _on_Area_body_exited(body):
	if body is Robot:
		move_tween.stop_all()
		player_inside = false
		move_back()
		$AnimationPlayer.play("stop_glow")
