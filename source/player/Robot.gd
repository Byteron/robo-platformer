extends KinematicBody
class_name Robot

enum ANIMATIONS { WALK, JUMP, FALL, DIVE, LAND, THROW }

const Wrench = preload("res://source/player/wrench/WrenchProjectile.tscn")

const DEAD_ZONE = 0.1

var last_checkpoint

var motion := Vector3()
var mouse_axis = Vector3()

var sprinting := false

var jumps := 0

var energy := 0.0

var can_charge = true
var coyote_jump = false

export(NodePath) var camera_path = null

export(NodePath) var first_checkpoint : NodePath

export var wrench_throw_force = 70.0

export var max_jumps := 2
export var max_energy := 100.0
export var energy_charge_rate = 50.0

export var has_jetpack := true setget _set_has_jetpack
export var has_cape := false

onready var foot_area := $FootArea

onready var anim_tree := $AnimationTree
onready var anim_player := $Robot/AnimationPlayer

onready var fsm := $FSM
onready var camera = null

onready var throw_position := $Robot/RobotArmature/Skeleton/WrenchPosition

onready var dust_particles := $Robot/RunningDust
onready var landing_dust_particles := $Robot/ImpactParticles

onready var jetpack := $Robot/RobotArmature/Skeleton/Jetpack

onready var jet_particles := [
	$Robot/RobotArmature/Skeleton/Jetpack/Particles1,
	$Robot/RobotArmature/Skeleton/Jetpack/Particles2
]

onready var debug_spatial := $Debug
onready var debug_motion := $Debug/Motion
onready var debug_look := $Debug/Look
onready var debug_input := $Debug/Input
onready var debug_prediction := $Debug/Prediction

func _input(event: InputEvent) -> void:

	if event is InputEventMouseMotion:
		mouse_axis.x += event.relative.normalized().x * 0.1
	if event.is_action("escape") and not event.is_echo() and event.is_pressed():
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _ready() -> void:
	last_checkpoint = get_node(first_checkpoint)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	fsm.host = self
	camera = get_node(camera_path)
	fsm.change_state("Idle")
	jumps = max_jumps
	set_jet_particles(false)
	set_dust_particles(false)
	_set_has_jetpack(has_jetpack)

func _process(delta: float) -> void:
	var motion_direction = translation - Vector3(motion.x, 0, motion.z)

	if motion_direction != translation:
		look_at(motion_direction, Vector3.UP)

	mouse_axis = lerp (mouse_axis, Vector3.ZERO, 0.1)

	sprinting = Input.is_action_pressed("sprint")

	get_tree().call_group("HUD", "set_boost", ceil(max_energy-energy / max_energy *  100.0))

	if can_charge and is_on_floor():
		if energy > 0:
			energy -= energy_charge_rate * delta

	if Input.is_action_just_pressed("throw") and not anim_tree.get("parameters/throw/active"):
			play(ANIMATIONS.THROW)
			throw_wrench()

	debug_sphere(debug_look, global_transform.basis.z * 1.2)
	debug_sphere(debug_motion, (Vector3(motion.x, 0, motion.z) / 5))

func debug_sphere(spatial: Spatial, direction: Vector3) -> void:
	spatial.global_transform.origin = global_transform.origin + direction + debug_spatial.translation

func slerp_direction(direction: Vector3, time: float) -> Vector3:
	var current_direction = motion.normalized()
	return current_direction.linear_interpolate(direction, time)

func play(animation: int) -> void:

	if anim_tree.get("parameters/state/current") == ANIMATIONS.LAND:
		return

	elif animation == ANIMATIONS.THROW:
		anim_tree.set("parameters/throw/active", true)
		return

	anim_tree.set("parameters/state/current", animation)

func get_walk_input_direction_relative() -> Vector3:
	var relative_input_direction = get_walk_input_direction().rotated(Vector3(0, 1, 0), camera.rotation.y)
	return relative_input_direction

func get_walk_input_direction() -> Vector3:
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

func debug_walk_spheres() -> void:
	pass

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

func set_jet_particles(value: bool) -> void:
	for p in jet_particles:
		p.emitting = value

func throw_wrench():
	var w = Wrench.instance()
	get_parent().call_deferred("add_child", w)
	w.global_transform = throw_position.global_transform
	var dir = $Robot/RobotArmature/Skeleton.global_transform.basis.z
	dir.y = 0.05
	w.add_torque(dir.rotated(Vector3.UP,PI/2)*300)
#	w.apply_torque_impulse(Vector3.UP)
	w.apply_central_impulse(dir* wrench_throw_force)

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
	if dust_particles.emitting != value:
		dust_particles.emitting = value

func change_state(state: String) -> void:
	fsm.change_state(state)

func respawn():
	var hud = get_tree().get_nodes_in_group("HUD")[0]
	hud.play_death()
	yield(hud, "respawn_ready")
	global_transform.origin = last_checkpoint.spawn_position.global_transform.origin

func _set_has_jetpack(value: bool) -> void:
	has_jetpack = value
	if jetpack:
		jetpack.visible = has_jetpack

func _on_FSM_state_changed(state_name) -> void:
	print(name, ": ", state_name)
