extends Spatial

onready var marker = $Marker
export var duration = 3.0


func _physics_process(delta):
	get_node("KinematicBody/roto-platform/Rotor").rotation_degrees.y -= 350 * delta

func _ready():
	var target = marker.translation
	$Tween.interpolate_property($KinematicBody, "translation", Vector3.ZERO, target, duration, Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($KinematicBody, "translation", target,  Vector3.ZERO,duration, Tween.TRANS_SINE,Tween.EASE_IN_OUT, duration)
	$Tween.start()
