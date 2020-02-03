extends Node
class_name Stat

signal max_value_changed(max_value)
signal value_changed(value)

var max_value := 0.0 setget _set_max_value
var value := 0.0 setget _set_value

func restore() -> void:
	_set_value(max_value)

func is_full() -> bool:
	return value == max_value

func is_empty() -> bool:
	return value == 0

func _set_max_value(_value: float) -> void:
	max_value = _value
	emit_signal("max_value_changed", max_value)

func _set_value(_value: float) -> void:
	value = clamp(_value, 0, max_value)
	emit_signal("value_changed", value)
