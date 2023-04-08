class_name AreaSelection extends Area2D

var size_area : Vector2
var size_area_x : float
var size_area_y : float
var min_pos_x : float
var min_pos_y : float
var upper_left_area : Vector2
var bottom_right_area : Vector2

var c_shape : CollisionShape2D
var shape : RectangleShape2D
var selected_lines : Array

var draw:bool = false

"""
Set the parameters to what is desired
"""
func set_params(upper_left, bottom_right) :
	min_pos_x = upper_left.x
	min_pos_y = upper_left.y
	upper_left_area = upper_left
	bottom_right_area = bottom_right
	size_area_x = bottom_right.x * 2
	size_area_y = bottom_right.y * 2
	size_area = Vector2(size_area_x, size_area_y)

"""
Launched by the uddate function
"""
func _draw() -> void:
	if draw :
		var size_rect : Vector2 = bottom_right_area - upper_left_area
		draw_rect(Rect2(-size_rect/2, size_rect), Color.aqua, false, 4)
		#draw_rect(Rect2(- min_pos_x, - min_pos_y, size_area_x, size_area_y), Color.aqua, false, 4)
		#draw_rect(Rect2(0, 0, size_area_x, size_area_y), Color.aqua, false, 4)

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
