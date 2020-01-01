extends State

const DEAD_ZONE := 0.2

var speed := 0.0
var max_speed := 0.0

export var max_speed_run := 8.0

export var max_speed_walk := 6.0

export var acceleration = 0.35
export var deceleration = 0.35

export var turn_threshhold := 0.7

func enter(host: Node) -> void:
	host = host as Robot
	host.can_charge = true
	host.motion.y = 0
	host.set_dust_particles(true)
	host.play("walk")

func input(host: Node, event: InputEvent) -> void:
	host = host as Robot

	if event.is_action_pressed("jump"):
		host.change_state("Jump")

func update(host: Node, delta: float) -> void:
	host = host as Robot

	if host.sprinting:
		max_speed = max_speed_run
	else:
		max_speed = max_speed_walk

	var input_direction = host.get_walk_input_direction()

	if input_direction:
		speed = clamp(speed + acceleration, 0, max_speed)
		host.motion.x = input_direction.x * speed
		host.motion.z = input_direction.z * speed
	elif Devices.current_device == Devices.DEVICES.KEYBOARD:
		speed = clamp(speed - deceleration, 0, max_speed)
		host.motion = host.motion.normalized() * speed
	else:
		speed = clamp(speed - deceleration, 0, host.motion.max_axis())
		host.motion = host.motion.normalized() * speed

	host.anim_tree.set("parameters/idle_to_walk/blend_amount", host.motion.length() / max_speed)
	host.anim_tree.set("parameters/time/scale", host.motion.length() / max_speed_walk * 1.5)

	host.dust_particles.process_material.set("scale", host.motion.length() / max_speed * 2.5)

	host.move_and_slide_with_snap(host.motion, Vector3.DOWN, Vector3.UP)

	if abs(host.motion.x) < 0.1 and abs(host.motion.z) < 0.1:
		host.change_state("Idle")

	elif not host.is_on_floor():
		host.jumps -= 1
		host.change_state("Fall")

func exit(host: Node) -> void:
	host = host as Robot
	host.anim_tree.set("parameters/idle_to_walk/blend_amount", 0)
	host.anim_tree.set("parameters/time/scale", 1.0)
	host.set_dust_particles(false)
