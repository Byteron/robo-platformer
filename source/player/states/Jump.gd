extends State

export var jump_force := 18

export var max_speed := 450
export var acceleration := 20
export var friction := 0.4

func enter(host: Node) -> void:
	host = host as Robot
	host.motion.y = jump_force
	host.play("jump")

func update(host: Node, delta: float) -> void:
	host = host as Robot

	host.motion.y -= Global.GRAVITY * delta

	if Input.is_action_just_released("jump") and host.motion.y > 0.1:
		host.motion.y = 0
	host.move_and_slide(host.motion, Vector3.UP)

	if host.is_on_floor():
		host.fsm.change_state("Idle")


func exit(host: Node) -> void:
	host = host as Robot
	host.motion.y = 0
