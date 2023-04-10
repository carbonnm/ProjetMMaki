extends Node

var Save := preload("Save.gd")
var SVGSyntax := preload("SVGSyntax.gd")


func export_to_svg() -> void:
	pass

func save() -> Dictionary:
	var save: Node = Save.new()
	save.set_save_nodes(nodes)
	return {}
