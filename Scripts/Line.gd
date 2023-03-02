extends Area2D

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
		var Min = Vector2.INF
		var Max = Vector2.ZERO
		for point in _line.points:
			if point.x < Min.x:
				Min.x = point.x
			if point.y < Min.y:
				Min.y = point.y
			if point.x > Max.x:
				Max.x = point.x
			if point.y > Max.y:
				Max.y = point.y
		draw_rect(Rect2(Min, Max - Min), Color.aqua, false, 4)

"""
Return the mean position of points in line2D.

Returns :
---------
center : Mean position of points in line2D.
"""
func get_line2D_center():
	var point_pos:Vector2
	var center = Vector2.ZERO
	for index in range(_line.get_point_count()):
		point_pos = _line.get_point_position(index)
		center += point_pos
		
	center = center/_line.get_point_count()
	
	return center
