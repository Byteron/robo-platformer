extends Spatial
class_name Gear

signal collected

export var floating = true

var collect_delay = 0.15
var spin_duration = 4.0
var collected = false

func _ready():
	$gear/Gear001.set("material/0", $gear/Gear001.get("material/0").duplicate())
	spin()

func spin():
	$Tween.interpolate_property($gear, "rotation_degrees:y", 0.0, 1080.0, spin_duration,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	if floating:
		$Tween.interpolate_property($gear, "translation:y", 0.0, 0.2, spin_duration/2,Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.interpolate_property($gear, "translation:y", 0.2, 0.0, spin_duration/2,Tween.TRANS_LINEAR, Tween.EASE_OUT, spin_duration/2)
	$Tween.start()

func collect():
	emit_signal("collected")
	$Particles.restart()
	collected = true
	$Tween.stop_all()
	var rot_y = self.rotation_degrees.y
	$Tween.interpolate_property($gear, "rotation_degrees:y", rot_y, rot_y+1080.0, spin_duration*0.7,Tween.TRANS_BACK, Tween.EASE_OUT)
	$Tween.interpolate_property($gear, "translation:y", $gear.translation.y, $gear.translation.y+1.5, spin_duration/2,Tween.TRANS_LINEAR, Tween.EASE_IN)
	var mat = $gear/Gear001.get("material/0")
	mat.flags_transparent=true
	$Tween.interpolate_property(mat, "albedo_color:a", 1.0, 0.0, spin_duration/6,Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()


	yield(get_tree().create_timer(collect_delay),"timeout")
	var cam = get_tree().get_nodes_in_group("main_cam")[0]
	var projected_pos = cam.unproject_position(global_transform.origin)
	get_tree().call_group("HUD","gear_collected", projected_pos)

	yield($Tween, "tween_all_completed")

	queue_free()

func _on_Area_body_entered(body):
	if body is Robot:
		if not collected:
			collect()
