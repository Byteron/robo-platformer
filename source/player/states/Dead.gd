extends State

func enter(host: Node) -> void:
	host = host as Robot
	host.emit_signal("died")
