extends Node

var customization: Dictionary = {
	"canvasname": "Canvas",
	"titlecolor": Color(0,0,0,1),
	"subtitlecolor": Color(0,0,0,1),
	"subsubtitlecolor": Color(0,0,0,1),
	"titlefont": "res://Assets/Fonts/arial_narrow_7.ttf",
	"subtitlefont": "res://Assets/Fonts/arial_narrow_7.ttf",
	"subsubtitlefont": "res://Assets/Fonts/arial_narrow_7.ttf",
	"backgroundcolor": Color(0.980392, 0.921569, 0.843137, 1)
}

func _init():
	for attributes in customization.keys():
		set_value(attributes)

func set_value(key: String):
	print(SceneSwitcher.get_param(key))
	if SceneSwitcher.get_param(key):
		customization[key] = SceneSwitcher.get_param(key)
