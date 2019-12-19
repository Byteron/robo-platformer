extends Node
class_name SoundBooth

onready var sfx := {}

func _ready() -> void:

	for child in _get_children_recursive(self, []):
		sfx[child.name] = child

func set_sfx_volume(sfx_name: String, volume: float) -> void:

	if not sfx.has(sfx_name):
		print("Could not find sfx: %s" % sfx_name)

	sfx[sfx_name].volume = volume

func play_sfx(sfx_name: String) -> void:

	if not sfx.has(sfx_name):
		print("Could not find sfx: %s" % sfx_name)

	sfx[sfx_name].play()

func stop_sfx(sfx_name: String) -> void:

	if not sfx.has(sfx_name):
		print("Could not find sfx: %s" % sfx_name)

	sfx[sfx_name].stop()

func _get_children_recursive(node: Node, children: Array) -> Array:
	for child in node.get_children():

		if child is Sound:
			children.append(child)
		else:
			var __ = _get_children_recursive(child, children)

	return children
