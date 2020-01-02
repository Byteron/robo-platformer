extends CanvasLayer
class_name HUD

var gears_displayed = 0 setget set_gears
var boost_displayed = 100.0 setget set_boost

var boost_visible = false
var gears_visible = false



onready var gear_label = $GearRect/Label
onready var boost_bar = $BoostBar

func _ready():
	Gamestate.hud = self

func set_gears(g):
	gears_displayed = g
	gear_label.text = str(gears_displayed)

func set_boost(b):
	boost_displayed = b
	boost_bar.value = b
	$BoostBar/Label.text = str(b)
	if !boost_visible:
		if b < 100.0:
			$BoostAnim.play("show")
			boost_visible=true
	else:
		if b >= 100.0:
			$BoostAnim.play("start_hide")
			boost_visible=false

func gear_collected(pos):
	var g = preload("res://source/hud/GearCollectIcon.tscn").instance()
	add_child(g)
	g.rect_position = pos
#	g.target = $GearPanel/Label.rect_position
	g.target = Vector2(50, 50)
	if !gears_visible and not $GearsAnim.is_playing():
		$GearsAnim.play("show")
	$GearRect/GearHideTimer.start()



func _on_GearsAnim_animation_finished(anim_name):
	if anim_name=="show":
		gears_visible = true
	if anim_name=="hide":
		gears_visible = false


func _on_GearHideTimer_timeout():
	$GearsAnim.play("hide")
