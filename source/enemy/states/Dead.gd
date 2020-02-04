extends State

func enter(host: Node) -> void:
	host = host as Enemy
	host.queue_free()
