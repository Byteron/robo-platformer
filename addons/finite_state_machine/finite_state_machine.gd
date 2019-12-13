tool
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_type("FiniteStateMachine", "Node", preload("source/FiniteStateMachine.gd"), preload("icons/fsm.png"))
	add_custom_type("State", "Node", preload("source/State.gd"), preload("icons/state.png"))

func _exit_tree() -> void:
	remove_custom_type("FiniteStateMachine")
	remove_custom_type("State")
