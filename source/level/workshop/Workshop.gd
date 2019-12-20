extends Spatial


func _input(event):
	$Viewport.unhandled_input(event)


func _on_Control_start_called():
	if !$ScreenFader.is_playing():
		$ScreenFader.play("fade_to_black")
		yield($ScreenFader, "animation_finished")
		get_tree().change_scene_to(load("res://source/World.tscn"))
