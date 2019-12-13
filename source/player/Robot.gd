extends KinematicBody
class_name Robot

const DEAD_ZONE = 0.1

export(NodePath) var camera_path = null

var motion := Vector3()

onready var anim_tree := $AnimationTree

onready var fsm := $FSM
onready var camera = null

func _ready() -> void:
	fsm.host = self
	camera = get_node(camera_path)
	fsm.change_state("Idle")

func _process(delta: float) -> void:
	if motion:
		look_at(translation - Vector3(motion.x, 0, motion.z), Vector3.UP)

func play(anim_name: String) -> void:
	pass

func get_walk_input_direction() -> Vector3:
	var input_direction := Vector3()

	input_direction.x = Input.get_joy_axis(0, JOY_AXIS_0)
	input_direction.z = Input.get_joy_axis(0, JOY_AXIS_1)
	input_direction.x = input_direction.x if abs(input_direction.x) > DEAD_ZONE else 0
	input_direction.z = input_direction.z if abs(input_direction.z) > DEAD_ZONE else 0
	return input_direction.rotated(Vector3(0, 1, 0), camera.rotation.y)

func get_look_input_direction() -> Vector3:
	var input_direction := Vector3()
	input_direction.x = Input.get_joy_axis(0, JOY_AXIS_2)
	input_direction.y = Input.get_joy_axis(0, JOY_AXIS_3)
	input_direction.x = input_direction.x if abs(input_direction.x) > DEAD_ZONE else 0
	input_direction.y = input_direction.y if abs(input_direction.y) > DEAD_ZONE else 0
	return input_direction

func change_state(state: String) -> void:
	fsm.change_state(state)

func _on_FSM_state_changed(state_name) -> void:
	print(name, ": ", state_name)
