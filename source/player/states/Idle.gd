extends State

func enter(host: Node) -> void:
	host = host as Robot
	host.play(host.ANIMATIONS.WALK)
	host.motion = Vector3()
	host.jumps = host.max_jumps

func input(host: Node, event: InputEvent) -> void:
	host = host as Robot

	if event.is_action_pressed("jump"):
		host.change_state("Jump")

func update(host: Node, delta: float) -> void:
	host = host as Robot
	host.can_charge = true
	var input_direction = host.get_walk_input_direction_relative()
	host.move_and_slide_with_snap(Vector3.ZERO, Vector3.DOWN, Vector3.UP)

	if not host.is_on_floor():
		host.jumps -= 1
		host.change_state("Fall")

	elif input_direction:
		host.change_state("Walk")

