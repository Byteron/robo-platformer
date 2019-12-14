extends State

var host : Robot = null

var jumped := false

export var jump_force := 18

export var max_speed := 450
export var acceleration := 15
export var friction := 0.4

export var air_drift := 0.1

func enter(host: Node) -> void:
	self.host = host as Robot
	host.play("jump")

func update(host: Node, delta: float) -> void:
	host = host as Robot

	var input_direction = host.get_walk_input_direction()*6

	if input_direction:
		host.motion.x = lerp(host.motion.x, input_direction.x, air_drift)
		host.motion.z = lerp(host.motion.z, input_direction.z, air_drift)

	host.motion.y -= Global.GRAVITY * delta

	if Input.is_action_just_released("jump") and host.motion.y > 0.1:
		host.motion.y = lerp(host.motion.y, 0, friction)

		if host.motion.y < 0.1:
			host.motion.y = 0

	host.move_and_slide(host.motion, Vector3.UP)

	if host.is_on_floor() and jumped:
		host.fsm.change_state("Idle")

func jump() -> void:
	host.motion.y = jump_force
	jumped = true

func exit(host: Node) -> void:
	host = host as Robot
	host.motion.y = 0
	jumped = false
