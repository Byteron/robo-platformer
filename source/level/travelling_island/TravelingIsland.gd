extends Spatial

export var speed = 4.0
export var unit_offset = 0.0

func _ready():
	$Path/PathFollow.unit_offset = unit_offset

func _physics_process(delta):
	$Path/PathFollow.offset += speed * delta
