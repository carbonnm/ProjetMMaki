extends Node

var scene_switcher: SceneSwitcher

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

func _init(sceneSwitcher: SceneSwitcher):
	scene_switcher = sceneSwitcher
	
	for attributes in customization.keys():
		set_value(attributes)

func set_value(key: String):
	if scene_switcher.get_param(key):
		customization[key] = scene_switcher.get_param(key)
