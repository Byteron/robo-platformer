extends Spatial

var turning_speed := 0.2
var lifting_speed := 0.15

func _physics_process(delta):
	var dir = Vector2()
	if Input.is_action_pressed("debug-left"):
		dir.x = -1
	if Input.is_action_pressed("debug-right"):
		dir.x = 1
	if Input.is_action_pressed("debug-up"):
		dir.y = -1
	if Input.is_action_pressed("debug-down"):
		dir.y = 1


	$Base/Back.rotate_y(dir.x * turning_speed * delta)
	$Base/Back/Arm/Platform.translate(Vector3(0,dir.y * lifting_speed,0))

	# $Base/Back/Arm/Platform/CSGPolygon.depth = $Base/Back/Arm/Platform.translation.y
