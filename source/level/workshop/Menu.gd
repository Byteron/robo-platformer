extends Control

signal start_called

var selection_idx = 0

var active_color ="#509dc6"
var inactive_color = "#1b55a7"

onready var labels = [
	$VBoxContainer/Start,
	$VBoxContainer/Settings,
	$VBoxContainer/Exit
]

func _unhandled_input(event):
	if event.is_action("ui_up") and !event.is_echo() and event.is_pressed():
		labels[selection_idx].set("custom_colors/font_color", inactive_color)
		selection_idx -= 1
		selection_idx = selection_idx % labels.size()
		labels[selection_idx].set("custom_colors/font_color", active_color)
	if event.is_action("ui_down") and !event.is_echo() and event.is_pressed():
		labels[selection_idx].set("custom_colors/font_color", inactive_color)
		selection_idx += 1
		selection_idx = selection_idx % labels.size()
		labels[selection_idx].set("custom_colors/font_color", active_color)

	if event.is_action("ui_accept") and !event.is_echo() and event.is_pressed():
		print(selection_idx)
		match selection_idx:
			0: start_game()
			1: show_settings()
			2: get_tree().quit()

func start_game():
	emit_signal("start_called")

func show_settings():
	pass
