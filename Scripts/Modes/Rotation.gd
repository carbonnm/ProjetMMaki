class_name Rotation extends Node

var Utils := preload("res://Scripts/Utilities/Utilities.gd").new()
var Mimic := preload("res://Scripts/Utilities/BuiltInMimic.gd").new()

"""
Process a rotation of Area2D's contained in a list according to mouse relative
position.

Parameters:
-----------
area2D_L: List of Areas2D to rotate. (Array)
mouse_position: Global mouse position. (Vector2)
mouse_relative: Relative position of the mouse according to 
InputEventMouseMotion. (float)
"""
func rotation(area2D_L, mouse_position, mouse_relative):
	# Transform Area2D_L to have an Array of Area2D's positions
	var area2D_L_positions = Utils.map(area2D_L, Mimic, "area2D_position", [])
	
	# Compute the central position of the circle surronding Area2D's
	var closure = Utils.get_positions_closure(area2D_L_positions)
	var center = Utils.get_positions_mean(closure)
	
	# Compute the rotation to make according to mouse's delta
	var current_mouse_position = mouse_position
	var prev_mouse_position = current_mouse_position - mouse_relative
	var delta = (current_mouse_position.angle_to_point(center) - prev_mouse_position.angle_to_point(center))

	# Makes the rotation of delta arount the center point
	for area2D in area2D_L:
		rotation_to_point(area2D,center,delta)

"""
Makes a rotation of an area2D according to a position and an angle.

Parameters:
-----------
area2D: Area2D to rotate.
center: Rotation center.
delta: Angle of rotation. 
"""
func rotation_to_point(area2D, center, delta):
	var radius = area2D.position.distance_to(center)
	var angle = fmod(area2D.position.angle_to_point(center)+delta,deg2rad(360))
	var coordinates = Vector2(cos(angle),sin(angle))*radius + center
	
	area2D.position = coordinates
	area2D.rotation += delta
