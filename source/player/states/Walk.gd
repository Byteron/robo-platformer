extends State

const DEAD_ZONE := 0.2

export var max_speed := 6.0
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

	if input_direction:
		host.motion = input_direction * max_speed
	else:
		host.motion.x = lerp(host.motion.x, 0, friction)
		host.motion.z = lerp(host.motion.z, 0, friction)

	host.anim_tree.set("parameters/idle_to_walk/blend_amount", host.motion.length() / max_speed)
	host.anim_tree.set("parameters/time/scale", host.motion.length() / max_speed * 1.5)

	host.move_and_slide_with_snap(host.motion, Vector3.DOWN, Vector3.UP)

	if abs(host.motion.x) < 0.1 and abs(host.motion.z) < 0.1:
		host.change_state("Idle")

	elif not host.is_on_floor():
		host.change_state("Fall")

func exit(host: Node) -> void:
	host = host as Robot
