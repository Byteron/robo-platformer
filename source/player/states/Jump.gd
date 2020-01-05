extends State

var host : Robot = null

var jumped := false
var speed := 0.0

var max_speed := 0.0

export var gravity_mod := 1.0

export var jump_force := 12.0

export var max_speed_walk := 6.0
export var max_speed_run := 8.0

export(float, 0.0, 1.0) var inertia = 0.95

func enter(host: Node) -> void:
	self.host = host as Robot
	host.can_charge = false
	host.motion.y = jump_force
	host.jumps -= 1
	host.play(host.ANIMATIONS.JUMP)

func update(host: Node, delta: float) -> void:
	host = host as Robot

	if host.sprinting:
		max_speed = max_speed_run
	else:
		max_speed = max_speed_walk

	var input_direction = host.get_walk_input_direction_relative()
	var lerped_direction = host.slerp_direction(input_direction, 1.0 - inertia)

	var target_motion = input_direction * max_speed
	host.motion.x = lerp(host.motion.x, target_motion.x, 1.0 - inertia)
	host.motion.z = lerp(host.motion.z, target_motion.z, 1.0 - inertia)

	host.debug_sphere(host.debug_prediction, lerped_direction)
	host.debug_sphere(host.debug_input, input_direction)

	host.motion.y -= Global.GRAVITY * delta * gravity_mod

	host.move_and_slide(host.motion, Vector3.UP)

	if Input.is_action_just_pressed("dive") and input_direction:
		host.change_state("Dive")
	elif Input.is_action_just_released("jump") and host.motion.y > 0.5:
		cut()
	elif Input.is_action_just_pressed("jump") and host.jumps > 0 and jumped:
		enter(host)
	elif Input.is_action_just_pressed("jump") and not host.jumps and jumped and host.has_jetpack:
		host.change_state("Jetpack")
	elif host.motion.y < 0.5:
		host.change_state("Fall")
	elif host.is_on_floor() and jumped:
		host.change_state("Idle")
	else:
		jumped = true

func cut():
	host.motion.y = 0.5;

func exit(host: Node) -> void:
	host = host as Robot
	jumped = false
