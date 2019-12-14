extends State

func enter(host: Node) -> void:
	host = host as Robot
	host.play("walk")
	host.motion = Vector3()

func input(host: Node, event: InputEvent) -> void:
	host = host as Robot

	if event.is_action_pressed("jump"):
		host.change_state("Jump")

func update(host: Node, delta: float) -> void:
	host = host as Robot

	var input_direction = host.get_walk_input_direction()
	host.move_and_slide_with_snap(Vector3.ZERO, Vector3.DOWN, Vector3.UP)

	if not host.is_on_floor():
		host.change_state("Fall")

	elif input_direction:
		host.change_state("Walk")

