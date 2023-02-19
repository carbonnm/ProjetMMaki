extends Area2D

var _selected_area:Array = []
var _size:Vector2

signal SendArea

func _ready():
	connect("area_shape_entered", self, "_on_Area2D_area_shape_entered")
	connect("area_shape_exited", self, "_on_Area2D_area_shape_exited")

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, _size), Color(0,0,100,0.1))

func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	_selected_area.append(area)

func _on_Area2D_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	_selected_area.erase(area)

func _exit_tree():
	emit_signal("SendArea", _selected_area)
