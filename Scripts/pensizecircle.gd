extends Node2D


var radius = 0
var width = 1
var circle_position = Vector2(10, 10)
var color = Color(0,0,0)

func _draw():
	draw_line(Vector2(5,10), Vector2(15, 10), color, width)

func set_circle_size(new_size):
	radius = new_size / 2
	update()
	
func set_line_size(new_size):
	width = new_size / 2
	update()

func get_line_size():
	return width

func set_line_color(new_color):
	color = new_color
	update()

#func set_circle_position(x,y):
#	print(x)
#	print(y)
#	circle_position = Vector2(0, 0)
#	update()
