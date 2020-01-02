extends RigidBody

onready var meshes = [
	$Wrench1,
	$Wrench2
]

func _ready():
	randomize()
	meshes[randi()%2].hide()




func _on_WrenchProjectile_body_entered(body):
	if body.is_in_group("jumpable_box"):
		body.explode()


func _on_DeathTimer_timeout():
	queue_free()
