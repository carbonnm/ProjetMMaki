extends Area2D

var size_area : Vector2
var area_pos
var size_area_x
var size_area_y
var min_pos_x
var min_pos_y
var upper_left_area
var bottom_right_area

var c_shape : CollisionShape2D
var shape : RectangleShape2D
var selected_lines : Array

var draw:bool = false

"""
Set the parameters to what is desired
"""
func set_params(min_x, min_y, size_x, size_y, upper_left, bottom_right) :
	min_pos_x = min_x
	min_pos_y = min_y
	size_area_x = size_x
	size_area_y = size_y
	upper_left_area = upper_left
	bottom_right_area = bottom_right
	size_area = Vector2(size_area_x, size_area_y)

func set_param(area_position) :
	self.position = area_position

"""
Launched by the uddate function
"""
func _draw() -> void:
	if draw :
		draw_rect(Rect2(-size_area_x/2, -size_area_y/2, size_area_x, size_area_y), Color.aqua, false, 4)

"""
Creation of the collisionshape
Parameters :
----------------
- selected_lines : Array
"""
func create_shape(selected_lines) -> void:
	c_shape = CollisionShape2D.new()
	shape = RectangleShape2D.new()
	
	var middle_point = (upper_left_area + bottom_right_area)/2
	c_shape.position = middle_point
	
	shape.extents = size_area / 2
	c_shape.shape = shape
	self.add_child(c_shape)


"""
Gets the center of the area2D
Returns : 
------------
- center : Vector2
"""
func get_area2D_center() -> Vector2 :
	var center = (upper_left_area + bottom_right_area + (position*2))/2
	print("centre", center)
	return center


"""
Center the area2D
"""
func center_area2D() -> void:
	var center = self.get_area2D_center()
	self.position += center


"""
Creation of the selection area
Parameters :
----------------
- selected_lines : Array
"""
func create_selection_area(selected_lines) -> void:
	self.center_area2D()
	#self.create_shape(selected_lines)
