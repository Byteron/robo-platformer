extends State

func enter(host: Node) -> void:
	host = host as Robot
	host.play(host.ANIMATIONS.FALL)
	host.motion = Vector3()
