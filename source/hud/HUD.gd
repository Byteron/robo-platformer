extends CanvasLayer
class_name HUD

signal respawn_ready

var gears_displayed = 0 setget set_gears

var boost_visible = false
var gears_visible = false

onready var gear_label = $GearRect/Label
onready var boost_bar = $BoostBar

func _physics_process(delta):
	if Input.is_action_just_pressed("debug-left"):
		play_death()

func _ready():
	Gamestate.hud = self

func set_gears(g):
	gears_displayed = g
	gear_label.text = str(gears_displayed)

func set_boost_max(max_boost: float) -> void:
	boost_bar.max_value = max_boost

func set_boost(boost: float) -> void:
	boost_bar.value = boost
	$BoostBar/Label.text = str(ceil(boost))
	if !boost_visible:
		if boost < 100.0:
			$BoostAnim.play("show")
			boost_visible = true
	else:
		if boost >= 100.0:
			$BoostAnim.play("start_hide")
			boost_visible = false

func set_max_health(max_health: float) -> void:
	print("TODO: Implement HUD.set_max_health()")

func set_health(health: float) -> void:
	print("TODO: Implement HUD.set_health()")

func gear_collected(pos):
	var g = preload("res://source/hud/GearCollectIcon.tscn").instance()
	add_child(g)
	g.rect_position = pos
#	g.target = $GearPanel/Label.rect_position
	g.target = Vector2(50, 50)
	if !gears_visible and not $GearsAnim.is_playing():
		$GearsAnim.play("show")
	$GearRect/GearHideTimer.start()

func play_death():
	$"Game Over Layer/AnimationPlayer".play("Death")

func _on_GearsAnim_animation_finished(anim_name):
	if anim_name=="show":
		gears_visible = true
	if anim_name=="hide":
		gears_visible = false


func _on_GearHideTimer_timeout():
	$GearsAnim.play("hide")
