extends Spatial


func _physics_process(delta):
	$sawbot/Circle.rotate_x(3*delta)
