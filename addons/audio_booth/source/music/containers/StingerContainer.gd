extends Node
class_name StingerContainer

var type := "stinger"

var counter := 0

export(String, "beat", "bar") var tick_type := "bar"
export var wait_ticks := 4
export(float, 0.0, 1.0) var probability := 0.0

onready var stingers := get_children()

func has_stinger() -> bool:
	return stingers.size() > 0

func tick() -> void:
	counter = (counter + 1) % wait_ticks

	if counter == 0:
		_play_random_stinger()

func _play_random_stinger() -> void:

	randomize()

	if randf() < probability:
		stingers[randi() % stingers.size()].play()