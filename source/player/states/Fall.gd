extends State

var speed := 0.0

export var max_speed := 6.0
export var acceleration := 0.6
export var friction := 0.4

func enter(host: Node) -> void:
	host = host as Robot
	host.play("jump")

func update(host: Node, delta: float) -> void:
	host = host as Robot

	var input_direction = host.get_walk_input_direction()

	if input_direction:
		speed = clamp(speed + acceleration, 0, max_speed)
		host.motion.x = input_direction.x * speed
		host.motion.z = input_direction.z * speed
	else:
		speed = lerp(speed, 0, friction)
		host.motion.x = lerp(host.motion.x, 0, friction)
		host.motion.z = lerp(host.motion.z, 0, friction)

	host.motion.y -= Global.GRAVITY * delta * 1.5

	if host.is_on_floor():
		host.fsm.change_state("Idle")

	host.move_and_slide_with_snap(host.motion, Vector3.DOWN, Vector3.UP)

func exit(host: Node) -> void:
	host = host as Robot
	host.motion.y = 0
	host.play("land")
