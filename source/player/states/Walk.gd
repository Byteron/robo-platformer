extends State

const DEAD_ZONE := 0.2

export var max_speed := 10
export var acceleration := 2
export var friction := 0.4

func enter(host: Node) -> void:
	host = host as Robot
	host.play("walk")

func input(host: Node, event: InputEvent) -> void:
	host = host as Robot

	if event.is_action_pressed("jump"):
		host.change_state("Jump")

func update(host: Node, delta: float) -> void:
	host = host as Robot

	var input_direction = host.get_walk_input_direction()

	if abs(input_direction.x) > DEAD_ZONE:
		host.motion.x = -input_direction.x * max_speed
	else:
		host.motion.x = lerp(host.motion.x, 0, friction)

	if abs(input_direction.z) > DEAD_ZONE:
		host.motion.z = -input_direction.z * max_speed
	else:
		host.motion.z = lerp(host.motion.z, 0, friction)

#	if input_direction.x == 1:
#		host.motion.x = clamp(host.motion.x - acceleration, -max_speed, 0)
#	elif input_direction.x == -1:
#		host.motion.x = clamp(host.motion.x + acceleration, 0, max_speed)
#	else:
#		host.motion.x = lerp(host.motion.x, 0, friction)
#
#	if input_direction.z == 1:
#		host.motion.z = clamp(host.motion.z + acceleration, 0, max_speed)
#	elif input_direction.z == -1:
#		host.motion.z = clamp(host.motion.z - acceleration, -max_speed, 0)
#	else:

	host.move_and_slide_with_snap(host.motion, Global.DOWN, Global.UP)

	if abs(host.motion.x) < 1 and abs(host.motion.z) < 1:
		host.change_state("Idle")

	elif not host.is_on_floor():
		host.change_state("Fall")

func exit(host: Node) -> void:
	host = host as Robot
