extends Spatial
class_name Gear

signal collected

var spin_duration = 4.0
var collected = false

func _ready():
	$gear/Gear001.set("material/0", $gear/Gear001.get("material/0").duplicate())
	spin()

func spin():
	$Tween.interpolate_property($gear, "rotation_degrees:y", 0.0, 1080.0, spin_duration,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
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
	print(mat)
	$Tween.interpolate_property($OmniLight,"light_energy", 1.0, 0.0, spin_duration/2,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.interpolate_property($OmniLight2,"light_energy", 1.0, 0.0, spin_duration/2,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.interpolate_property(mat, "albedo_color:a", 1.0, 0.0, spin_duration/6,Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	queue_free()
	
func _on_Area_body_entered(body):
	if body is Robot:
		if not collected:
			collect()
