extends KinematicBody
class_name Enemy

export var max_health := 0.0

onready var health := $Stats/Health as Stat
onready var fsm := $FSM as FiniteStateMachine

func _ready() -> void:
	health.max_value = max_health
	health.restore()
	change_state("Idle")

func heal(value: float) -> void:
	health.value += value

func hurt(value: float) -> void:
	health.value -= value

func kill() -> void:
	health.value = 0

func change_state(new_state: String) -> void:
	fsm.change_state(new_state)

func _on_Health_value_changed(value) -> void:
	if health.is_empty():
		change_state("Dead")

func _on_FSM_state_changed(state_name) -> void:
	print("%s: %s" % [name, state_name])
