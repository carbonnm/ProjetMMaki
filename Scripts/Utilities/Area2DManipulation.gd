extends Node


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
