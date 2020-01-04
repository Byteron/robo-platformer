extends Node

export var fade_duration = 1.0
export (NodePath) var target
onready var tween = $Tween


func fade(from: float, to: float) -> void:
	var targets = [get_node(target)]

	#detect if we have a single mesh or scene (as in gltf import)
	if targets[0] is Spatial:
		targets = targets[0].get_children()

	for model in targets:
		var mesh = model.mesh

		for i in mesh.get_surface_count():
			#duplicate material and reassign
			var mat = mesh.surface_get_material(i).duplicate()
			mat.flags_transparent=true
			model.set_surface_material(i, mat)

			$Tween.interpolate_property(mat, "albedo_color:a", from, to,fade_duration ,Tween.TRANS_LINEAR, Tween.EASE_IN)

	$Tween.start()



