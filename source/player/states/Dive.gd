extends State

var host : Robot = null

export var gravity_mod := 1.0

export var jump_force := 12.0

export var max_speed := 10.0

export var acceleration := 0.6
export var friction := 0.1

func enter(host: Node) -> void:
	self.host = host as Robot
	host.motion = host.get_walk_input_direction() * jump_force
	host.motion.y = jump_force / 2
	host.play("jump")

func update(host: Node, delta: float) -> void:
	host = host as Robot

	var input_direction = host.get_walk_input_direction()

	if input_direction:
		host.motion.x = input_direction.x * max_speed
		host.motion.z = input_direction.z * max_speed
	else:
		host.motion.x = lerp(host.motion.x, 0, friction)
		host.motion.z = lerp(host.motion.z, 0, friction)

	host.motion.y -= Global.GRAVITY * delta * gravity_mod

	host.move_and_slide(host.motion, Vector3.UP)

	if host.is_on_floor():
		host.change_state("Idle")

func exit(host: Node) -> void:
	host = host as Robot
