extends State

var speed := 0.0

var max_speed := 0.0

export var gravity_mod := 1.2

export var max_speed_walk := 6.0
export var max_speed_run := 6.0

export var acceleration := 0.6

export var friction := 0.1

func enter(host: Node) -> void:
	host = host as Robot
	host.play("fall")

func update(host: Node, delta: float) -> void:
	host = host as Robot

	if host.foot_ray.is_colliding():
		host.foot_ray.get_collider().explode()
		host.change_state("Jump")
		return

	if host.sprinting:
		max_speed = max_speed_run
	else:
		max_speed = max_speed_walk

	var input_direction = host.get_walk_input_direction()

	if input_direction:
		speed = clamp(speed + acceleration, 0, max_speed)
		host.motion.x = input_direction.x * speed
		host.motion.z = input_direction.z * speed
	else:
		speed = lerp(speed, 0, friction)
		host.motion.x = lerp(host.motion.x, 0, friction)
		host.motion.z = lerp(host.motion.z, 0, friction)

	host.motion.y -= Global.GRAVITY * delta * gravity_mod

	if Input.is_action_just_pressed("dive") and input_direction:
		host.change_state("Dive")
	elif host.is_on_floor():
		host.emit_dust()
		host.fsm.change_state("Idle")
	elif Input.is_action_just_pressed("jump") and host.jumps > 0:
			host.change_state("Jump")
	elif Input.is_action_just_pressed("jump") and not host.jumps and host.energy < host.max_energy:
		host.change_state("Jetpack")

	host.move_and_slide_with_snap(host.motion, Vector3.DOWN, Vector3.UP)

func exit(host: Node) -> void:

	host = host as Robot
	host.play("land")

