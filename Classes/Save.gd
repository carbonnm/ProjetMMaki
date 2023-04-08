extends Node


export var MAX_SAVES: int = 10

var save_nodes: Array = []
var saves: Array = []

func set_save_nodes(nodes: Array):
	save_nodes = nodes

func save() -> Dictionary:
	var save_dict: Dictionary = {
		"Line2D": [],
		"TextEdit": [],
		"Sprite": []
	}
		
	save_dict = retrieve_elements(save_dict)
	add_saves(save_dict)
	
	return save_dict

func retrieve_elements(save_dict: Dictionary) -> Dictionary:
	for node in save_nodes:
		if node is Line2D:
			var trans_node: Line2D = node.duplicate(true)
			trans_node.set_transform(node.global_transform)
			save_dict["Line2D"].append(trans_node)
		elif node is TextEdit:
			var trans_node: TextEdit = node.duplicate(true)
			trans_node.set_transform(node.global_transform)
			save_dict["TextEdit"].append(trans_node)
		elif node is Sprite:
			var trans_node: Sprite = node.duplicate(true)
			trans_node.set_transform(node.global_transform)
			save_dict["Sprite"].append(trans_node)
		else:
			set_save_nodes(save_nodes + node.get_children())
		
		save_nodes.erase(node)
	
	if save_nodes.size() != 0:
		save_dict = retrieve_elements(save_dict)
	
	return save_dict

func add_saves(save: Dictionary) -> void:
	if saves.size() == MAX_SAVES:
		saves.pop_back()
	
	saves.push_front(save)

func erase_save(index: int) -> void:
	if saves.size() > index:
		saves.remove(index)
