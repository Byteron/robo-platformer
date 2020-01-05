extends State

var speed := 0.0

var max_speed := 0.0

export var gravity_mod := 1.2

export var max_speed_walk := 6.0
export var max_speed_run := 6.0

export var acceleration := 0.6

export var friction := 0.1
export(float, 0.0, 1.0) var inertia := 0.95

func enter(host: Node) -> void:
	host = host as Robot
	host.can_charge = false
	host.play(host.ANIMATIONS.FALL)

func update(host: Node, delta: float) -> void:
	host = host as Robot

	for body in host.foot_area.get_overlapping_bodies():
		if body.is_in_group("jumpable_box"):
			body.explode()
			if body.explosive: host.change_state("BounceHigh")
			else: host.change_state("BounceLow")
			return

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

	if Input.is_action_just_pressed("dive") and input_direction:
		host.change_state("Dive")
	elif host.is_on_floor():
		host.emit_dust()
		host.fsm.change_state("Idle")
		host.play(host.ANIMATIONS.LAND)
	elif Input.is_action_just_pressed("jump") and host.jumps > 0:
			host.change_state("Jump")
	elif Input.is_action_just_pressed("jump") and not host.jumps and host.energy < host.max_energy and host.has_jetpack:
		host.change_state("Jetpack")

	host.move_and_slide_with_snap(host.motion, Vector3.DOWN, Vector3.UP)

func exit(host: Node) -> void:
	host = host as Robot

