extends Spatial

var zoom_level = 0.5

export(NodePath) var target_path = null

export var offset := Vector3(0, 1, 0)

export var max_distance := 10
export var max_rotation_speed := 4

export(Curve) var distance_curve : Curve = null

export(float, 0.0, 1.0) var smoothing := 0.8

onready var target : Robot = null

onready var gimbal_v := $VerticalGimbal
onready var camera := $VerticalGimbal/Camera

func _ready() -> void:
	if target_path:
		target = get_node(target_path)
	else:
		set_process(false)

func _process(delta: float) -> void:
	translation = target.translation + offset

	var input_direction = target.get_look_input_direction()
	# rotation_degrees.y = 0
	print(input_direction)

	zoom_level = clamp(zoom_level + input_direction.y * delta, 0, 1)

	rotation_degrees.y += -input_direction.x * max_rotation_speed
	gimbal_v.rotation_degrees.x = lerp(0, -90, distance_curve.interpolate(zoom_level))
	camera.translation = Vector3(0, 0, lerp(0, max_distance, zoom_level))

func get_direction() -> Vector3:
	if not target:
		return Vector3()

	var direction = camera.translation.direction_to(target.translation)
	direction.y = 0
	return direction
