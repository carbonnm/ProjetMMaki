extends Node

export var MAX_SAVES: int = 10

var save_nodes: Array = []
var saves: Array = []

"""
Function that returns saves attribute.

Returns:
--------
The saves attribute. (Array)
"""
func get_saves() -> Array:
	return saves

"""
Function that returns the last save made.

Returns:
--------
The last save made. (Dictionary)
"""
func get_last_save() -> Dictionary:
	return saves[0]

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

"""
Function that save previously specified nodes and their children 
into a dictionary containing all Line2Ds, TextEdits and Sprites.
It adds the dictionary to saves Array. Then returns the dictionary 
created.

Returns:
--------
The dictionary created with all Line2Ds, TextEdits and Sprites. (Dictionary)
"""
func save() -> Dictionary:
	
	var save_dict: Dictionary = {
		"BackgroundColor": Color(0,0,0),
		"Line2D": [],
		"TextEdit": [],
		"Sprite": []
	}
	
	save_dict = retrieve_elements(save_dict)
	add_saves(save_dict)
	
	return save_dict

"""
Function that add a save at the front of the
array of saves. It erases the older save if the number
of saves was alreary highter than MAX_SAVES.

Parameters:
-----------
save: The save to add. (Dictionary)
"""
func add_saves(save: Dictionary) -> void:
	if saves.size() == MAX_SAVES:
		saves.pop_back()
	
	saves.push_front(save)

"""
Function that erase the save in the saves Array at specified index.

Parameters:
-----------
index: Index of the save to erase. (int)
"""
func erase_save(index: int) -> void:
	if saves.size() > index:
		saves.remove(index)

"""
Function that retrieve and arrange Line2D, TextEdit and Sprite
elements from specified nodes to insert them in a dictionary
Then returns the dictionary.

Parameters:
-----------
save_dict: The dictionary to complete. (Dictionary)

Returns:
--------
The dictionary created with all Line2Ds, TextEdits and Sprites. (Dictionary)
"""
func retrieve_elements(save_dict: Dictionary) -> Dictionary:
	
	for node in save_nodes:
		if node is Line2D:
			var trans_node: Line2D = apply_global_transform(node)
			trans_node.points = trans_node.global_transform.xform(trans_node.points)
			trans_node.global_transform = Transform2D()
			save_dict["Line2D"].append(trans_node)
		elif node is TextEdit:
			var trans_node: TextEdit = apply_global_transform(node)
			save_dict["TextEdit"].append(trans_node)
		elif node is Sprite:
			var trans_node: Sprite = apply_global_transform(node)
			save_dict["Sprite"].append(trans_node)
		elif node is ColorRect:
			save_dict["BackgroundColor"] = node.color
		else:
			set_save_nodes(save_nodes + node.get_children())
		
		save_nodes.erase(node)
	
	if save_nodes.size() != 0:
		save_dict = retrieve_elements(save_dict)
	
	return save_dict

"""
Function that applies the global transfomation of a node's parent
to the global transformation of the node. The node can be a 
Control node or a Node2D node. Then returns the transformed node.

Parameters:
-----------
node: Node to apply it's parent global transformation. (Node)

Returns:
--------
The transformed node. (Node)
"""
func apply_global_transform(node: Node) -> Node:
	var dup_node = node.duplicate(true)
	var transform: Transform2D = node.get_parent().global_transform
	if dup_node is Control:
		dup_node.rect_position += transform.get_origin()
		dup_node.rect_rotation += transform.get_rotation()
		dup_node.rect_scale *= transform.get_scale()
	if dup_node is Node2D:
		dup_node.transform *= transform
	
	return dup_node


