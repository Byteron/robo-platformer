extends CanvasLayer
class_name HUD

var gears_displayed = 0 setget set_gears
var boost_displayed = 100.0 setget set_boost
var boost_visible = false

onready var gear_label = $GearPanel/Label
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
