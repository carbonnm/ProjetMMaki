extends Node

var Utils := preload("res://Scripts/Utilities/Utilities.gd").new()
var Mimic := preload("res://Scripts/Utilities/BuiltInMimic.gd").new()

"""
Rescale the selected area (zoom/dezoom)
Input :
------------
area2D_L : Area2D : List of Areas2D to rescale.
mouse_position : Vector2 : Global mouse position.
mouse_relative : Vector2 : The mouse position relative to the previous position (position at the last frame).
"""
func rescale(area2D_L, mouse_position, mouse_relative) -> void:
	var positions: Array = Utils.map(area2D_L, Mimic, "area2D_position", [])
	var closure: Array = Utils.get_positions_closure(positions)
	var center: Vector2 = Utils.get_positions_mean(closure)
	var sensitivity: float = 0.01
	var magnitude: float =  - center.distance_to(mouse_position) + center.distance_to(mouse_position+mouse_relative)
	magnitude *= sensitivity
	
	var is_zoom_min : bool = false
	for area2D in area2D_L:
		if area2D.scale + Vector2(magnitude, magnitude) < Vector2(0, 0):
			is_zoom_min = true
	
	if not is_zoom_min :	
		for area2D in area2D_L:
			var prev_scale: Vector2 = area2D.scale
			var distance_to_center: Vector2 = -center + area2D.position
			area2D.scale += Vector2(magnitude, magnitude)
			area2D.position = center + distance_to_center/prev_scale*area2D.scale
