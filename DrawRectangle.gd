extends Area2D

var _size:Vector2

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, _size), Color(0,0,100,0.1))
