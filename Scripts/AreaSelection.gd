extends Area2D

var size_area
var area_pos
var min_pos_x
var min_pos_y
var size_area_x
var size_area_y

var _selection_area : Area2D

var draw:bool = false

func _ready() -> void:
	_selection_area = Area2D.new()
	self.add_child(_selection_area)

"""
Set the parameters to what is desired
"""
func set_params(min_x, min_y, size_x, size_y) :
	min_pos_x = min_x
	min_pos_y = min_y
	size_area_x = size_x
	size_area_y = size_y


"""
Launched by the uddate function
"""
func _draw() -> void:
	if draw :
#		print("Draw")
#		print(min_pos_x)
#		print(min_pos_y)
#		print(size_area_x)
#		print(size_area_y)
		draw_rect(Rect2(min_pos_x, min_pos_y, size_area_x, size_area_y), Color.aqua, false, 4)
