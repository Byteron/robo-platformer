extends State

const DEAD_ZONE := 0.2
const WALK_LERP_WEIGHT := 0.35

var speed := 0.0
var boost := 0.0

var input_direction_keyboard = Vector3()

export var max_speed := 5.0
export var sprint_boost := 3.0

export(float, 0.0, 1.0) var inertia = 0.8

export var turn_threshhold := 0.7

func enter(host: Node) -> void:
	host = host as Robot
	host.can_charge = true
	host.motion.y = 0
	input_direction_keyboard = Vector3()
	host.set_dust_particles(true)
	host.play(host.ANIMATIONS.WALK)

func input(host: Node, event: InputEvent) -> void:
	host = host as Robot

	if event.is_action_pressed("jump"):
		host.change_state("Jump")

func update(host: Node, delta: float) -> void:
	host = host as Robot

	boost = sprint_boost if host.sprinting else 0

	var input_direction = host.get_walk_input_direction_relative()
	var lerped_direction = host.slerp_direction(input_direction, 1.0 - inertia)

	var target_motion = input_direction * (max_speed + boost)
	host.motion.x = lerp(host.motion.x, target_motion.x, 1.0 - inertia)
	host.motion.z = lerp(host.motion.z, target_motion.z, 1.0 - inertia)

	host.debug_sphere(host.debug_prediction, lerped_direction)
	host.debug_sphere(host.debug_input, input_direction)

	var blend_x = host.motion.length() / max_speed
	var blend_y = max(0, host.motion.length() - max_speed) / sprint_boost

	host.anim_tree.set("parameters/walk/blend_position", Vector2(blend_x, blend_y))

	host.dust_particles.process_material.set("scale", host.motion.length() / max_speed * 2.5)

	host.move_and_slide_with_snap(host.motion, Vector3.DOWN, Vector3.UP)

	if abs(host.motion.x) < 0.1 and abs(host.motion.z) < 0.1:
		host.change_state("Idle")

	elif not host.is_on_floor():
		host.coyote_jump = true
		host.change_state("Fall")

func exit(host: Node) -> void:
	host = host as Robot
	host.anim_tree.set("parameters/walk/blend_position", Vector2())
	host.set_dust_particles(false)
