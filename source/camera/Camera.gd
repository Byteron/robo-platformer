extends Camera

export(NodePath) var target_path = null

onready var target = null

func _ready() -> void:
	target = get_node(target_path)

func _process(delta: float) -> void:
	translation = target.translation + Vector3(0, 1, -3)
