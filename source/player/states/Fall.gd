extends State

export var max_speed := 450
export var acceleration := 15
export var friction := 0.4
export var air_drift := 0.1

func enter(host: Node) -> void:
	host = host as Robot
	host.motion.y = 0
	host.play("fall")

func update(host: Node, delta: float) -> void:
	host = host as Robot

	var input_direction = host.get_walk_input_direction()*6

	if input_direction:
		host.motion.x = lerp(host.motion.x, input_direction.x, air_drift)
		host.motion.z = lerp(host.motion.z, input_direction.z, air_drift)

	host.motion.y -= Global.GRAVITY * delta

	if host.is_on_floor():
		host.fsm.change_state("Idle")

	host.move_and_slide_with_snap(host.motion, Vector3.DOWN, Vector3.UP)

func exit(host: Node) -> void:
	host = host as Robot
	host.motion.y = 0
