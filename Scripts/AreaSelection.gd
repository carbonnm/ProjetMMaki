extends Area2D

var max_x : float
var max_y : float
var min_x : float
var min_y : float

var _selection_area : Area2D
var c_shape: CollisionShape2D
var shape: RectangleShape2D
var draw:bool = false

func _ready() -> void :
	_selection_area = Area2D.new()
	self.add_child(_selection_area)

func set_params(max_x, max_y, min_x, min_y) :
	max_x = max_x
	max_y = max_y
	min_x = min_x
	min_y = min_y

func _draw() -> void:
	if draw :
		draw_rect(Rect2(min_x, min_y, max_x - min_x, max_y - min_y), Color.aqua, false, 4)
		print("I'm drawing")

