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
	var mapped_array: Array = []
	for element in array:
		var arguments: Array = args.duplicate()
		arguments.push_front(element)
		var result = script.callv(function_name,arguments)
		mapped_array.append(result)
		
	return mapped_array

"""
Return an array containing the upper-left and the bottom-right in this order corner from
an array of positions.

!!! The upper-left and bottom-right are according to Godot scene representation
wich has his y axis downside. It means that the upper-left position is lower than 
bottom-right one, which could be confusing. !!!

Parameters:
-----------
array: Array of positions to get corners. (Array)

Returns:
--------
corners_positions: Array containing the upper_left and the bottom-right corner
of the array of points. (Array)
"""
func get_positions_corners(array:Array) -> Array:
	var upper_left: Vector2 = Vector2.INF
	var bottom_right: Vector2 = -1*Vector2.INF
	for position in array:
		upper_left = Vector2(min(upper_left.x,position.x),min(upper_left.y,position.y))
		bottom_right = Vector2(max(bottom_right.x,position.x),max(bottom_right.y,position.y))
		
	return [upper_left,bottom_right]
	
"""
Return an array containing closure positions of an array of positions. That
is to say the positions of points on the closure of the shape surrounding arrays.

Parameters:
-----------
array: Array of positions to get closure. (Array)

Returns:
--------
closure_positions: Array containing closure positions of the array of points. (Array)
"""
func get_positions_closure(array:Array) -> Array:
	if array.size() <= 2:
		return array
	
	# Cacule les positions extrêmes de l'Array afin de déterminer un cercle
	# contenant tous les points
	var extreme: Array = []
	var max_distance: float = 0.0
	for i in range(array.size()):
		for j in range(i+1, array.size()):
			var distance_to_closure: float = array[i].distance_to(array[j])
			if distance_to_closure > max_distance:
				extreme = [array[i],array[j]]
				max_distance = distance_to_closure
	
	# Calcul des positions n'étant pas reprises dans le rayon du cercle centré
	# sur les extrêmes afin de recentrer le cercle en prenant compte des autres
	# valeurs éloignées
	var out: Array = []
	for position in array:
		var radius: float = extreme[0].distance_to(extreme[1])/2
		var distance_to_extreme1: float = position.distance_to(extreme[0])
		var distance_to_extreme2: float = position.distance_to(extreme[1])
		if radius < distance_to_extreme1 && radius < distance_to_extreme2:
			out.append(position)
	
	# Récursion en prenant ces nouvelles valeurs élognées pour les ajouter 
	# à la fermeture de la forme 
	var closure: Array = extreme.duplicate()
	if out.size() != 0:
		closure.append(get_positions_mean(get_positions_closure(out)))
		
	return closure
	
"""
Return the mean position of positions in the Array.

Parameters:
-----------
array: Array of positions to get the center. (Array)

Returns :
---------
center : Mean position according to array vectors. (Vector2)
"""
func get_positions_mean(array:Array) -> Vector2:
	var accumulator: Vector2 = Vector2.ZERO
	for position in array:
		accumulator += position
	
	return accumulator/array.size()

"""
Get the first child with type of the node.

Parameters :
------------
node : Node to get the child (Node).
type : Type of the child node (String).

Returns :
---------
child : Child of the node with specified type (Node).
"""
func get_child_of_type(node: Node, type: String) -> Node:
	var num_of_child: int = node.get_child_count()
	for i in range(num_of_child):
		var child: Node = node.get_child(i)
		if child.is_class(type):
			return child
	return null
