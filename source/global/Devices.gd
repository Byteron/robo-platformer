extends Node

signal device_changed(device)

enum DEVICES { KEYBOARD, GAMEPAD }

var input_map := {
#	jump = ["_", "A"],
}

var current_device: int = DEVICES.KEYBOARD

func _input(event: InputEvent) -> void:

	if current_device == DEVICES.KEYBOARD:

		if event is InputEventJoypadButton or event is InputEventJoypadMotion:
			current_device = DEVICES.GAMEPAD
			emit_signal("device_changed", current_device)

	elif current_device == DEVICES.GAMEPAD:

		if not event is InputEventJoypadButton and not event is InputEventJoypadMotion:
			current_device = DEVICES.KEYBOARD
			emit_signal("device_changed", current_device)

func get_key_string(action: String) -> String:
	return input_map[action][current_device]
