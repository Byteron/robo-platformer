extends KinematicBody
class_name Robot

const DEAD_ZONE = 0.1

export(NodePath) var first_checkpoint : NodePath
var last_checkpoint

var motion := Vector3()
var mouse_axis = Vector3()

var sprinting := false

var jumps := 0

var energy := 0.0

export var max_jumps := 2
export var max_energy := 100.0

export(NodePath) var camera_path = null

onready var anim_tree := $AnimationTree
onready var anim_player := $Robot/AnimationPlayer

onready var fsm := $FSM
onready var camera = null

onready var dust_particles = $Robot/RunningDust
onready var landing_dust_particles = $Robot/ImpactParticles

onready var jet_particles = [
	$Robot/RobotArmature/Skeleton/Jetpack/Particles1,
	$Robot/RobotArmature/Skeleton/Jetpack/Particles2
]

func _ready() -> void:
	last_checkpoint = get_node(first_checkpoint)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	fsm.host = self
	camera = get_node(camera_path)
	fsm.change_state("Idle")
	jumps = max_jumps
	set_jet_particles(false)
	set_dust_particles(false)

func _process(delta: float) -> void:
	var carrot = translation - Vector3(motion.x, 0, motion.z)

	if carrot != translation:
		look_at(carrot, Vector3.UP)

	mouse_axis = lerp (mouse_axis, Vector3.ZERO, 0.1)

	sprinting = Input.is_action_pressed("sprint")

func play(anim_name: String) -> void:

	var idx = 0

	if anim_name == "jump": idx = 1
	if anim_name == "fall": idx = 2
	if anim_name == "land": idx = 3

	if anim_tree.get("parameters/state/current") == 3:
		return

	if anim_name == "walk": idx = 0

	anim_tree.set("parameters/state/current", idx)

func get_walk_input_direction() -> Vector3:
	return get_raw_walk_input_direction().rotated(Vector3(0, 1, 0), camera.rotation.y)

func get_raw_walk_input_direction() -> Vector3:
	var input_direction := Vector3()

	if Devices.current_device == Devices.DEVICES.GAMEPAD:
		input_direction.x = Input.get_joy_axis(0, JOY_AXIS_0)
		input_direction.z = Input.get_joy_axis(0, JOY_AXIS_1)
		input_direction.x = input_direction.x if abs(input_direction.x) > DEAD_ZONE else 0
		input_direction.z = input_direction.z if abs(input_direction.z) > DEAD_ZONE else 0

	elif Devices.current_device == Devices.DEVICES.KEYBOARD:
		input_direction.x = int(Input.is_action_pressed("walk_right")) - int(Input.is_action_pressed("walk_left"))
		input_direction.z = int(Input.is_action_pressed("walk_down")) - int(Input.is_action_pressed("walk_up"))
		input_direction = input_direction.normalized()

	return input_direction

func get_look_input_direction() -> Vector3:
	var input_direction := Vector3()

	var pad_direction = Vector3()
	var mouse_direction = mouse_axis

	pad_direction.x = Input.get_joy_axis(0, JOY_AXIS_2)
	pad_direction.y = Input.get_joy_axis(0, JOY_AXIS_3)
	pad_direction.x = pad_direction.x if abs(pad_direction.x) > DEAD_ZONE else 0
	pad_direction.y = pad_direction.y if abs(pad_direction.y) > DEAD_ZONE else 0

	input_direction = mouse_direction if mouse_direction.length() > pad_direction.length() else pad_direction

	return input_direction

func _input(event):
	if event is InputEventMouseMotion:
		mouse_axis.x += event.relative.normalized().x * 0.1

func set_jet_particles(value: bool) -> void:
	for p in jet_particles:
		p.emitting = value

func emit_dust():
	if -motion.y < 8: return

	var dust_scale = range_lerp(-motion.y,9,20,0.3 ,1.0)
	dust_scale = clamp(dust_scale, 0.5, 1.0)
	landing_dust_particles.process_material.scale = 5.0*dust_scale
	landing_dust_particles.process_material.initial_velocity = 14.0* dust_scale
	landing_dust_particles.process_material.damping = 85.0 * dust_scale
	landing_dust_particles.amount = int(24.0* dust_scale)
	landing_dust_particles.restart()

func set_dust_particles(value: bool) -> void:
	dust_particles.emitting = value

func change_state(state: String) -> void:
	fsm.change_state(state)

func _on_FSM_state_changed(state_name) -> void:
	print(name, ": ", state_name)

func respawn():
	global_transform.origin = last_checkpoint.spawn_position.global_transform.origin
