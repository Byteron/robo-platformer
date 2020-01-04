extends State

var host : Robot = null

var speed := 0.0

export var gravity_mod := 1.0

export var max_speed := 12.0

export var acceleration := 0.6
export var friction := 0.1

func enter(host: Node) -> void:
	self.host = host as Robot
	host.can_charge = false
	host.motion.x = host.get_walk_input_direction().x * max_speed
	host.motion.z = host.get_walk_input_direction().z * max_speed
	speed = max_speed
	host.play(host.ANIMATIONS.DIVE)

func update(host: Node, delta: float) -> void:
	host = host as Robot

	var input_direction = host.get_walk_input_direction()

	if input_direction:
		host.motion.x = input_direction.x * speed
		host.motion.z = input_direction.z * speed

	if host.is_on_floor():
		host.motion.y = 0
		speed = lerp(speed, 0, friction)
		host.set_dust_particles(true)
	elif not host.has_cape:
		host.motion.y -= Global.GRAVITY * delta * gravity_mod
		host.set_dust_particles(false)

	host.move_and_slide(host.motion, Vector3.UP)

	if host.is_on_floor() and not Input.is_action_pressed("dive") or host.is_on_floor() and speed < 0.5:
		host.change_state("Idle")

func exit(host: Node) -> void:
	host = host as Robot
