extends Control


export(String, DIR) var level_directory := ""
export(Array, String) var levels = [""]

onready var options := $CenterContainer/VBoxContainer/OptionButton

func _ready() -> void:
	for level in levels:
		options.add_item(level)

func _on_Play_pressed() -> void:
	var level = options.get_item_text(options.get_selected_id())
	var path = "%s/%s.tscn" % [level_directory, level]

	get_tree().change_scene(path)
