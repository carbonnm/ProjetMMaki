extends Node

var Save := preload("Save.gd").new()
var SVGSyntax := preload("SVGSyntax.gd").new()

var save_nodes: Array = []

"""
Function that set nodes to save. Childs nodes of specified
nodes are also saved. If a child of an already specified 
parent is given, it will be saved twice.

Parameters:
-----------
nodes: Nodes to save. (Array)
"""
func set_save_nodes(nodes: Array) -> void:
	save_nodes = nodes

func export_to_svg() -> void:
	var save: Dictionary = save()

"""
Function create a save of specified nodes and return
the save.

Returns:
--------
The save made. (Dictionary)
"""
func save() -> Dictionary:
	Save.set_save_nodes(save_nodes)
	Save.save()
	return Save.get_last_save()

func create_syntax() -> Dictionary:
