extends Area2D

var _selected_area:Array = []
var _size:Vector2

signal SendArea



func _ready():
	var _enter_error = connect("area_shape_entered", self, "_on_Area2D_area_shape_entered")
	var _exit_error = connect("area_shape_exited", self, "_on_Area2D_area_shape_exited")

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, _size), Color(0,0,100,0.1))

func _on_Area2D_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	# Check if the area with the corresponding shape is in the area.
	if not [area, _area_shape_index] in _selected_area:
		var can_add = true
		# Check if the area is already here with a different index, if yes, don't
		# append the area.
		for _area in _selected_area:
			if area in _area:
				can_add = false
		
		if can_add:
			_selected_area.append([area, _area_shape_index])

func _on_Area2D_area_shape_exited(_area_rid, area, _area_shape_index, _local_shape_index):
	# Remove the area from the list if the shape who exited was the one added.
	if [area, _area_shape_index] in _selected_area:
		_selected_area.erase([area, _area_shape_index])

func _exit_tree():
	emit_signal("SendArea", _selected_area)
