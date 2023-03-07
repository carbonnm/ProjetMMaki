extends Node

"""
Rescale the selected area (zoom/dezoom)
Input :
------------
area2D_L : Area2D : List of Areas2D to rescale.
mouse_position : Vector2 : Global mouse position.
mouse_relative : Vector2 : The mouse position relative to the previous position (position at the last frame).
"""
func rescale(area2D_L, mouse_position, mouse_relative):
	for area2D in area2D_L:
		if mouse_position.x - mouse_relative.x < mouse_position.x  :
			area2D.scale += Vector2(0.03, 0.03)
		elif mouse_position - mouse_relative > mouse_position:
			area2D.scale -= Vector2(0.03, 0.03)
