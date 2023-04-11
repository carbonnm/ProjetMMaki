extends Node


"""
Return an array containing the upper-left and the bottom-right 
corner in this order from an PoolVector2Array of positions.

!!! The upper-left and bottom-right are according to Godot 
scene representation wich has his y axis downside. It means
that the upper-left position is lower than bottom-right one, 
which could be confusing. !!!

Parameters:
-----------
positions: Positions to get corners from. (PoolVector2Array)

Returns:
--------
The positions containing the upper_left and the bottom-right 
corner in this order. (PoolVector2Array)
"""
func get_positions_corners(positions: PoolVector2Array) -> Array:
	var upper_left: Vector2 = Vector2.INF
	var bottom_right: Vector2 = -1*Vector2.INF
	for position in positions:
		upper_left = Vector2(min(upper_left.x,position.x),min(upper_left.y,position.y))
		bottom_right = Vector2(max(bottom_right.x,position.x),max(bottom_right.y,position.y))
		
	return [upper_left,bottom_right]
