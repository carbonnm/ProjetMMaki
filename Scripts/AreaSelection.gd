extends Area2D

var size_area

var _selection_area : Area2D
var draw:bool = false

func _ready() -> void:
	_selection_area = Area2D.new()
	self.add_child(_selection_area)

"""
Set the parameters to what is desired
"""
func set_params(area_position, area_size_vec) :
	_selection_area.position = area_position
	size_area = area_size_vec


"""
Launched by the uddate function
"""
func _draw() -> void:
	if draw :
		draw_rect(Rect2(Vector2(100, 100), size_area), Color.aqua, false, 4)
