class_name Stroke extends Area2D

var _line: Line2D
var c_shape: CollisionShape2D
var shape: RectangleShape2D
var zoom:Vector2
var HitBoxs:Array

var draw:bool = false
var skipready:bool = false

func _ready() -> void:
	if !skipready:
		_line = Line2D.new()
		self.add_child(_line)

func set_params(lineWidth, color, _zoom):
	_line.width = lineWidth
	_line.default_color = color
	zoom = _zoom

# create a collision shape for each point in the line
func CreateCollisions():
	
	var Point_size: int = _line.points.size()
	if Point_size < 2:
		return
	
	HitBoxs.clear()
	for index in range (Point_size-1):
		HitBoxs.append(Create_Shape(_line.points[index], _line.points[index+1]))

# create the shape
func Create_Shape(point1:Vector2, point2:Vector2):
	c_shape = CollisionShape2D.new()
	shape = RectangleShape2D.new()
	c_shape.shape = shape
	var middle_point = point1.linear_interpolate(point2, 0.5)
	c_shape.position = middle_point
	shape.extents.x = point1.distance_to(point2) / 2
	shape.extents.y = _line.width / 2
	
	var _rotation = point1.angle_to_point(point2)
	c_shape.rotate(_rotation)
	
	self.add_child(c_shape)
	
func _draw() -> void:
	if draw:
		var corners = get_line2D_corner()
		var upper_left = corners[0]
		var bottom_down = corners[1]
		draw_rect(Rect2(upper_left, bottom_down - upper_left), Color.aqua, false, 4)

func get_line2D_corner():
	var upper_left = Vector2.INF
	var bottom_right = -1*Vector2.INF
	for point in _line.points:
		upper_left = Vector2(min(upper_left.x,point.x),min(upper_left.y,point.y))
		bottom_right = Vector2(max(bottom_right.x,point.x),max(bottom_right.y,point.y))
		
	return [upper_left,bottom_right]

"""
Return the mean position of points in line2D.

Returns :
---------
center : Mean position of points in line2D.
"""
func get_line2D_center():
	var corners = get_line2D_corner()
	var upper_left = corners[0]
	var bottom_down = corners[1]
	return (upper_left+bottom_down)/2
