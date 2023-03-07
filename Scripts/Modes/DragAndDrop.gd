extends Node

"""
Drag and drop and element by changing its position.

Input :
-----------
- area2D_L : Array : List of Areas2D to drag and drop.
- mouse_relative : Vector2 : The mouse position relative to the previous position (position at the last frame).
"""
func drag_and_drop(area2D_L, mouse_relative):
	for area2D in area2D_L:
		area2D.position += mouse_relative
