class_name Stroke extends Area2D

var _line: Line2D
var hitbox: CollisionShape2D
var zoom:Vector2
var global_corners: Array

var draw:bool = false
var skipready:bool = false

func Setup() -> void:
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
	
	# Retrive Points in line
	var points: PoolVector2Array = _line.points
	
	# Compute frontiers
	var left_side_frontier := PoolVector2Array()
	var right_side_frontier := PoolVector2Array()
	for index in range(points.size()):
		var perpendicular_vector: Vector2
		if index == 0:
			perpendicular_vector = (-points[index] + points[index+1]).tangent().normalized()
		else:
			perpendicular_vector = (-points[index-1] + points[index]).tangent().normalized()
		
		left_side_frontier.append(points[index] + (perpendicular_vector*_line.width))
		right_side_frontier.append(points[index] - (perpendicular_vector*_line.width))
	
	right_side_frontier.invert()
	
	# Compute perimeter
	var frontier := left_side_frontier + right_side_frontier
	frontier.append(left_side_frontier[0])
	
	Create_Shape(frontier)

# create the shape
func Create_Shape(frontier: PoolVector2Array):
	hitbox = CollisionShape2D.new()
	var perimeter := ConvexPolygonShape2D.new()
	hitbox.shape = perimeter
	perimeter.points = frontier
	
	self.add_child(hitbox)
	
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
	global_corners = [corners[0]+global_position,corners[1]+global_position]
	var upper_left = corners[0]
	var bottom_down = corners[1]
	return (upper_left+bottom_down)/2

"""
Centers position of the Area2D at the center of the line.
"""
func center_area2D_to_center(line_points):
	
	var line_center = self.get_line2D_center()
	self.position += line_center
	
	for index in range(line_points.size()):
		line_points[index] -= line_center
	
	self._line.points = line_points

# change the point in the ligne to make it more smooth by using an algorithm
func Curve2D_Transformer(_camera):
	var curve = Curve2D.new()
	curve.bake_interval = 1.0 * _camera.zoom.x
	for point in self._line.points:
		curve.add_point(point)
	var new_points = curve.get_baked_points()
	
	self.center_area2D_to_center(new_points)
	
	curve = null
	self.CreateCollisions()

func get_corners_counting_rotation():
	var positions:Array = []
	for point in _line.points:
		positions.append(Vector2(cos(rotation),sin(rotation))*point + global_position)

	var upper_left = -1*Vector2.INF
	var bottom_right = Vector2.INF
	for pos in positions:
		upper_left = Vector2(max(upper_left.x,pos.x),max(upper_left.y,pos.y))
		bottom_right = Vector2(min(bottom_right.x,pos.x),min(bottom_right.y,pos.y))
	
	return [upper_left,bottom_right]
