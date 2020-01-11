extends StaticBody

var robo = null

var zipping = false

export var destination : NodePath

export var hook_time = 0.25
export var zip_time = 5.0

onready var hook := $Hook
onready var tween := $Tween

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and robo and not zipping:
		zip()
	elif event.is_action_pressed("interact") and robo and zipping:
		tween.stop_all()
		tween.remove_all()
		call_deferred("_on_Tween_tween_all_completed")

func zip() -> void:

	if not destination:
		return

	robo.change_state("Zip")
	robo.lock()
	zipping = true

	var dest = get_node(destination)

	tween.interpolate_property(robo, "global_transform:origin", robo.global_transform.origin,  hook.global_transform.origin, hook_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(robo, "global_transform:origin", hook.global_transform.origin,  dest.hook.global_transform.origin, zip_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT, hook_time)
	tween.start()

func _on_Area_body_entered(body: Node) -> void:
	if body is Robot:
		robo = body

func _on_Area_body_exited(body: Node) -> void:
	if not zipping:
		robo = null

func _on_Tween_tween_all_completed() -> void:
	robo.unlock()
	robo.change_state("Fall")
	zipping = false
	robo = null
