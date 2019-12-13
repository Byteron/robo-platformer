extends Control
class_name HUD

var gears_displayed = 0 setget set_gears

onready var gear_label = $BottomLeftPanel/GearContainer/Label

func _ready():
	Gamestate.hud = self

func set_gears(g):
	gears_displayed = g
	gear_label.text = str(gears_displayed)
	
