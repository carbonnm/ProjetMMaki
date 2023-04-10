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
func _init(nodes: Array) -> void:
	save_nodes = nodes

func export_to_svg() -> void:
	# Create a save of specified nodes.
	var save: Dictionary = save()
	
	# Construct the syntax element.
	var construction: Dictionary = construct_syntax_element(save)
	
	
	#SVGSyntax.get_svg_string()

func construct_syntax_element(save) -> Dictionary:
	# Initialisation
	var syntax_block: Dictionary
	var size: Vector2
	var path_d: PoolVector2Array
	var path_fill: Color
	var text_label: String
	var text_position: Vector2
	var text_font_size: int
	var text_font_family: String
	var text_fill: Color
	var image_position: Vector2
	var image_size: Vector2
	var image_href: String
	return {}

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
