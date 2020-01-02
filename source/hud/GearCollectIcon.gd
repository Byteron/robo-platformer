extends Control
var target setget set_target
var move_duration = 0.45

func set_target(pos):
	target = pos
	$Tween.interpolate_property(self, "rect_position", rect_position, target, move_duration, Tween.TRANS_SINE,Tween.EASE_IN)
	$Tween.interpolate_property(self, "modulate", Color.white, Color.transparent, move_duration, Tween.TRANS_SINE,Tween.EASE_IN)
	$Tween.start()


func _on_Tween_tween_all_completed():
	Gamestate.gear_collected()
	queue_free()
