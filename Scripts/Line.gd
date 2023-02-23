extends Area2D

var _line: Line2D
var c_shape: CollisionShape2D
var shape: RectangleShape2D

var draw:bool = false

func _ready() -> void:
	_line = Line2D.new()
	self.add_child(_line)	
	c_shape = CollisionShape2D.new()
	shape = RectangleShape2D.new()
	c_shape.shape = shape
	self.add_child(c_shape)

func set_params(lineWidth, color, pos):
	_line.width = lineWidth
	_line.default_color = color
	# - c_shape.get_parent().position to applied the global position and not the parent relatate position
	c_shape.position = pos - c_shape.get_parent().position

func add_point(pos):
	# pos of the parent needed to get the global position and not the parent relativ position
	var parentPos: Vector2 = _line.get_parent().position
	_line.add_point(pos - parentPos)
	#comment the code below to avoid multiple CollishionShap
	c_shape = CollisionShape2D.new()
	shape = RectangleShape2D.new()
	c_shape.position = pos - parentPos
	c_shape.shape = shape
	self.add_child(c_shape)
	
#	update()

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


