extends Area
class_name Checkpoint

onready var spawn_position = $SpawnPosition


func _on_Checkpoint_body_entered(body):
	if body is Robot:
		body.last_checkpoint = self
