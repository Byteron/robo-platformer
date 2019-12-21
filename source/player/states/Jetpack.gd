extends State

var host : Robot = null

var speed := 0.0

var max_speed := 0.0

export var gravity_mod := 1.0

export var thrust := 35.0


export var max_speed_jet := 10.0
export var max_speed_walk := 6.0
export var max_speed_run := 8.0

export var acceleration := 0.6
export var friction := 0.1

func enter(host: Node) -> void:
	self.host = host as Robot
	host.play("jump")

func update(host: Node, delta: float) -> void:
	host = host as Robot

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

	host.move_and_slide(host.motion, Vector3.UP)

	if Input.is_action_pressed("jump") and host.energy < host.max_energy:
		host.motion.y += thrust * delta
		host.motion.y = clamp(host.motion.y, 0, max_speed_jet)
		host.energy += thrust * delta
	elif host.motion.y < 0.5 and not Input.is_action_pressed("jump") or host.motion.y < 0.5 and host.energy >= host.max_energy:
		host.change_state("Fall")

func exit(host: Node) -> void:
	host = host as Robot
	host.motion.y = 0