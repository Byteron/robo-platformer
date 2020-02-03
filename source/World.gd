extends Spatial

onready var robot = $Robot as Robot
onready var hud = $HUD as HUD

func _ready() -> void:
	pass # Music.play_song("Roboshop")

func _on_Robot_died():
	hud.play_death()
	yield(hud, "respawn_ready")
	robot.respawn()
