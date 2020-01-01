extends RigidBody

onready var meshes = [
	$Mesh1,
	$Mesh2
]
var decay_delay_min = 0.2
var decay_delay_max = 0.5
func _ready():
	randomize()
	var mesh = meshes[randi()%2]
	mesh.rotate_y(randi()%2*180.0)
	mesh.show()
	mesh.mesh = mesh.mesh.duplicate()
	var mat = mesh.mesh.surface_get_material(0).duplicate()
	mesh.mesh.surface_set_material(0, mat)
	mat.flags_transparent = true
	var c = mat.albedo_color
	var decay_delay = rand_range(decay_delay_min, decay_delay_max)
	$Tween.interpolate_property(mat, "albedo_color", c, Color(c.r, c.g, c.b, 0.0),2.0,Tween.TRANS_LINEAR,Tween.EASE_IN,decay_delay)
	$Tween.start()


func _on_Tween_tween_all_completed():
	queue_free()
