extends Spatial


func _physics_process(delta):
	$blades.rotate_y(2.4*delta)
