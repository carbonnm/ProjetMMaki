extends Node


"""
Return the first element of an Array

Parameters:
-----------
array: Array to examine. (Array)

Returns:
--------
array: Element with index 0 in the Array. (Array) 
"""
func get_first(array:Array) -> Array:
	return array[0]
	
"""
Return the position of an Area2D

Parameters:
-----------
area2D: Area to examine. (Area2D)

Returns:
--------
position: Position of the Area2D (Vector2)
"""
func area2D_position(area2D:Area2D) -> Vector2:
	return area2D.get_position()
