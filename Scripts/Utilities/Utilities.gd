extends Node

"""
Create a copy of the array with each element transformed by the function.

Parameters:
-----------
array: Array of initial elements. (Array)
script: Instance of the class containing the function (Object)
function_name: Name of the function to call on each elements. (String)
args: List of arguments for the function. (Array)

Returns:
--------
mapped_array: Copy of initial array with transformed elements by the function. (Array)
"""
func map(array: Array, script: Object, function_name: String, args: Array) -> Array:
	var mapped_array = []
	for element in array:
		var arguments = args.duplicate()
		arguments.push_front(element)
		var result = script.callv(function_name,arguments)
		mapped_array.append(result)
		
	return mapped_array

"""
Return an array containing the upper-left and the bottom-right corner from
an array of positions.

Parameters:
-----------
array: Array of positions to get corners. (Array)

Returns:
--------
corners_positions: Array containing the upper_left and the bottom-right corner
of the array of points. (Array)
"""
func get_positions_corners(array:Array) -> Array:
	var upper_left = Vector2.INF
	var bottom_right = -1*Vector2.INF
	for position in array:
		upper_left = Vector2(min(upper_left.x,position.x),min(upper_left.y,position.y))
		bottom_right = Vector2(max(bottom_right.x,position.x),max(bottom_right.y,position.y))
		
	return [upper_left,bottom_right]
	
"""
Return the mean position of positions in the Array.

Parameters:
-----------
array: Array of positions to get the center. (Array)

Returns :
---------
center : Mean position according to array vectors. (Vector2)
"""
func get_positions_center(array:Array) -> Vector2:
	var accumulator = Vector2.ZERO
	for position in array:
		accumulator += position
	
	return accumulator/array.size()
