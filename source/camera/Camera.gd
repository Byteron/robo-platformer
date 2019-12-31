extends Spatial

var zoom_level = 0.5
var scroll_zoom_level = 0.5

export var limit_bottom = 0.0

export(NodePath) var target_path = null

export var offset := Vector3(0, 1, 0)

export var max_distance := 10.0
export var max_rotation_speed := 280.0
export var follow_rotation_speed := 80.0

export(Curve) var distance_curve : Curve = null
export var collision_margin := 2.0
export(float, 0.0, 1.0) var smoothing := 0.95

onready var target : Robot = null

onready var zoom_timer := $ZoomTimer
onready var tween := $Tween

onready var gimbal_v := $VerticalGimbal
onready var camera := $VerticalGimbal/ClippedCamera

func _ready() -> void:
	if target_path:
		target = get_node(target_path)
	else:
		set_process(false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_up"):
		scroll_zoom_level = clamp(scroll_zoom_level - 0.05, 0, 1)
	elif event.is_action_pressed("scroll_down"):
		scroll_zoom_level = clamp(scroll_zoom_level + 0.05, 0, 1)

func _process(delta: float) -> void:
	var space_state = get_world().direct_space_state

	var result = space_state.intersect_ray(target.translation + Vector3(0, 1, 0), target.translation + Vector3(0, -3, 0), [target])

	if result:
		translation = lerp(translation, result.position + offset, 1.0 - smoothing)
	else:
		translation = lerp(translation, target.translation + offset, 1.0 - smoothing)

	translation.y = clamp(translation.y, limit_bottom, translation.y)

	var look_input_direction = target.get_look_input_direction()

	if not look_input_direction and zoom_timer.is_stopped():
		zoom_timer.start(3)

	if look_input_direction and not zoom_timer.is_stopped():
		zoom_timer.stop()

	if look_input_direction and tween.is_active():
		tween.stop_all()

	if not tween.is_active() and Devices.current_device == Devices.DEVICES.GAMEPAD:
		zoom_level = clamp(zoom_level + look_input_direction.y * delta, 0, 1)
		scroll_zoom_level = zoom_level
	elif not tween.is_active() and Devices.current_device == Devices.DEVICES.KEYBOARD:
		zoom_level = lerp(zoom_level, scroll_zoom_level, 1.0 - smoothing)

	rotation_degrees.y += -look_input_direction.x * max_rotation_speed * delta
	rotation_degrees.y += -target.get_raw_walk_input_direction().x * follow_rotation_speed * delta

	gimbal_v.rotation_degrees.x = lerp(0, -90, distance_curve.interpolate(zoom_level))

	camera.translation = Vector3(0, 0, lerp(0, max_distance, zoom_level))

func get_direction() -> Vector3:
	if not target:
		return Vector3()

	var direction = camera.translation.direction_to(target.translation)
	direction.y = 0
	return direction

func _on_ZoomTimer_timeout() -> void:
	tween.interpolate_property(self, "zoom_level", zoom_level, 0.5, 3.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
