extends Spatial

var zoom_level = 0.5

export(NodePath) var target_path = null

export var offset := Vector3(0, 1, 0)

export var max_distance := 10
export var max_rotation_speed := 4

export(Curve) var distance_curve : Curve = null

export(float, 0.0, 1.0) var smoothing := 0.95

onready var target : Robot = null

onready var gimbal_v := $VerticalGimbal
onready var dummy := $VerticalGimbal/Dummy
onready var camera := $VerticalGimbal/Camera

func _ready() -> void:
	if target_path:
		target = get_node(target_path)
	else:
		set_process(false)

func _process(delta: float) -> void:
	var space_state = get_world().direct_space_state

	var result = space_state.intersect_ray(target.translation + Vector3(0, 1, 0), target.translation + Vector3(0, -3, 0), [target])

	if result:
		translation = lerp(translation, result.position + offset, 1.0 - smoothing)
	else:
		translation = lerp(translation, target.translation + offset, 1.0 - smoothing)

	var input_direction = target.get_look_input_direction()

	zoom_level = clamp(zoom_level + input_direction.y * delta, 0, 1)

	rotation_degrees.y += -input_direction.x * max_rotation_speed
	gimbal_v.rotation_degrees.x = lerp(0, -90, distance_curve.interpolate(zoom_level))

	dummy.translation = Vector3(0, 0, lerp(0, max_distance, zoom_level))

	result = space_state.intersect_ray(target.translation + Vector3(0, 1, 0), dummy.global_transform.origin, [target])

	var new_camera_position = dummy.translation

	if result:
		new_camera_position.z = target.global_transform.origin.distance_to(result.position)

	camera.translation = lerp(camera.translation, new_camera_position, .5)

func get_direction() -> Vector3:
	if not target:
		return Vector3()

	var direction = camera.translation.direction_to(target.translation)
	direction.y = 0
	return direction
