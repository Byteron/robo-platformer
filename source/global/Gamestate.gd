extends Node

var hud : HUD
var gears = 0

func gear_collected():
	gears += 1
	hud.gears_displayed = gears
