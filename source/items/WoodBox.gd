extends StaticBody

var scrap_scene = preload("res://source/items/WoodScrapParticle.tscn")
export var scrap_amount = 8

func _input(event):
	if event.is_action("debug-up"):
		explode()


func explode():
	$Particles.restart()
	$Particles2.restart()
	for i in scrap_amount:
		var s = scrap_scene.instance()
		$v3.hide()
		$CollisionShape.set_deferred("disabled", true)
		get_parent().call_deferred("add_child",s)
		randomize()
		var dir = Vector3(rand_range(-0.5,0.5), 0, rand_range(-0.5,0.5))
		s.translation = translation  + dir
		s.rotate_y(rand_range(0.0,360.0))
		var i_dir = dir
		i_dir.y = rand_range(0.6,1.0)

		s.apply_impulse(Vector3.ZERO, i_dir * rand_range(2.0, 5.0))
