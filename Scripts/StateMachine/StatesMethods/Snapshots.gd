extends Node


const MAXSNAPSHOTS: int = 10

var parent_node: Node
var target_node: Node
var snapshots: Array = []
var current_index: int = 0


"""
Initialize a new instance of the Snapshots Class.

Parameters :
------------
parentNode: The parent node of the child to make a snapshot. (Node)
targetNode: The node to make a snapshot of. (Node)
"""
func _init(parentNode: Node, targetNode: Node):
	parent_node = parentNode
	target_node = targetNode

"""
Get the last snapshot.

Returns:
--------
The last snapshot. (Node)
"""
func get_last_snapshot() -> Node:
	return reload_snapshot(current_index-1)

"""
Get the next snapshot.

Returns:
--------
The next snapshot. (Node)
"""
func get_next_snapshot() -> Node:
	return reload_snapshot(current_index+1)

"""
Create a new snapshot.

The new snapshot is added at the end of the snapshots dictionary. If the
maximum number of snapshots is reached, the oldest snapshot is deleted.

Returns:
--------
The added snapshot. (Node)
"""
func create_snapshot() -> Node:
	var elements: Node = target_node.duplicate(true)
	
	# Removes outdated snapshots
	if snapshots.size() != 0 and current_index != snapshots.size()-1:
		snapshots.resize(current_index+1)
	
	if snapshots.size() > MAXSNAPSHOTS:
		var out_of_scope: Node = snapshots[0]
		snapshots.remove(0)
		out_of_scope.queue_free()
	
	snapshots.append(elements)
	
	current_index = snapshots.size()-1
	return elements

"""
Reload a snapshot at the specified index.

Parameters:
-----------
index: The index of the snapshot to reload. (int)

Returns:
--------
The reloaded snapshot. (Node)
"""
func reload_snapshot(index: int) -> Node:
	if index >= 0 and index < snapshots.size():
		var prev_elements: Node = target_node
		var new_elements: Node = snapshots[index].duplicate(true)
		parent_node.add_child(new_elements)
		
		#DEPRECATED
		#prev_elements.queue_free()
		prev_elements.hide()
		
		target_node = new_elements
		current_index = index
		
		return new_elements
		
	return target_node
