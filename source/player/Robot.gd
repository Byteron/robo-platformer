extends KinematicBody
class_name Robot

export(NodePath) var camera_path = null

var motion := Vector3()

onready var fsm := $FSM
onready var camera = null

func _ready() -> void:
	fsm.host = self
	camera = get_node(camera_path)
	fsm.change_state("Idle")

func _process(delta: float) -> void:
	if motion:
		look_at(translation + Vector3(-motion.x, 0, -motion.z), Global.UP)

func play(anim_name: String) -> void:
	pass

func get_walk_input_direction() -> Vector3:
	var input_direction := Vector3()
	input_direction.x = Input.get_joy_axis(0, JOY_AXIS_0)
	input_direction.z = Input.get_joy_axis(0, JOY_AXIS_1)
	return input_direction

func get_look_input_direction() -> Vector3:
	var input_direction := Vector3()
	input_direction.x = Input.get_joy_axis(0, JOY_AXIS_2)
	input_direction.z = Input.get_joy_axis(0, JOY_AXIS_3)
	return input_direction
func change_state(state: String) -> void:
	fsm.change_state(state)

func _on_FSM_state_changed(state_name) -> void:
	print(name, ": ", state_name)
