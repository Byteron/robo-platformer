extends Node
class_name FiniteStateMachine

signal state_changed(state_name)

var states := {}

var current_state = null

var host = null

func _ready() -> void:

	for node in get_children():
		states[node.name] = node

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.input(host, event)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.update(host, delta)

func register_state(id: String, node_path: String):
	states[id] = get_node(node_path)

func change_state(new_state: String) -> void:

	if current_state:
		current_state.exit(host)

	current_state = states[new_state]

	current_state.enter(host)

	emit_signal("state_changed", current_state.name)

func is_current_state(state_name) -> bool:

	if not current_state:
		return false

	return current_state.name == state_name
