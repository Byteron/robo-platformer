extends Node

export (NodePath) var target
onready var tween = $Tween

func _ready():
	pass

func fade(alpha):
	var targets = [get_node(target)]

	#detect if we have a single mesh or scene (as in gltf import)
	if targets[0] is Spatial:
		targets = targets[0].get_children()

	for model in targets:
		var mesh = model.mesh

		for i in mesh.surface_get_material_count():

			#duplicate material and reassign
			var mat = mesh.surface_get_material(i).duplicate()
			mesh.surface_set_material(i, mat)

			mat.flags_transparent=true




#	$Tween.interpolate_property(mat, "albedo_color:a", 1.0, 0.0, spin_duration/6,Tween.TRANS_LINEAR, Tween.EASE_IN)
#	$Tween.start()
