class_name Title extends Area2D

var _Label : Label
var c_shape: CollisionShape2D
var shape: RectangleShape2D
var zoom:Vector2

var stylebox_empty := StyleBoxEmpty.new()


var draw:bool = false

func _ready() -> void:
	_Label = Label.new()
	_Label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# code pour change le background de Label
	_Label.add_stylebox_override("normal", stylebox_empty)
	
	self.add_child(_Label)

func set_params(_bbcode_enabled, chosen_title, _size_Label, position_Label):
#	_Label.bbcode_enabled = bbcode_enabled
	_Label.text = chosen_title
#	_Label.rect_size = size_Label
	_Label.rect_global_position = position_Label
#	_Label.fit_content_height
	

## create a collision shape for each point in the line
#func CreateCollisions():	
#	HitBoxs.clear()
#	HitBoxs.append(Create_Shape(_line.points[index], _line.points[index+1]))

# create the shape
func Create_Shape():
	c_shape = CollisionShape2D.new()
	shape = RectangleShape2D.new()
	
	var center = _Label.rect_position + Vector2(_Label.rect_size.x/2, _Label.rect_size.y/2)
	
#	center.x -= 8
	c_shape.position = center
	
	shape.extents = _Label.rect_size / 2
#	shape.extents.x -= 8
	c_shape.shape = shape
	
	self.add_child(c_shape)

	
func _draw() -> void:
	if draw:
#		var corners = get_line2D_corner()
#		var upper_left = corners[0]
#		var bottom_down = corners[1]
		draw_rect(Rect2(_Label.rect_position, _Label.rect_size), Color.aqua, false, 4)



#func get_line2D_corner():
#	var upper_left = Vector2.INF
#	var bottom_right = -1*Vector2.INF
#	for point in _line.points:
#		upper_left = Vector2(min(upper_left.x,point.x),min(upper_left.y,point.y))
#		bottom_right = Vector2(max(bottom_right.x,point.x),max(bottom_right.y,point.y))
#
#	return [upper_left,bottom_right]

"""
Return the mean position of points in line2D.

Returns :
---------
center : Mean position of points in line2D.
"""
func get_Label_center():
	return (_Label.rect_global_position + Vector2(_Label.rect_size.x/2, _Label.rect_size.y/2))

"""
Centers position of the Area2D at the center of the line.
"""
func center_area2D_to_center():
	var Label_center = self.get_Label_center()
	
	self.position = Label_center
	_Label.rect_global_position -= Label_center
	
	self._Label = _Label
#	var line_center = self.get_line2D_center()
#	self.position += line_center
#
#	for index in range(line_points.size()):
#		line_points[index] -= line_center
#
#	self._line.points = line_points



func createLabel():
	self.center_area2D_to_center()
	self.Create_Shape()

func ChangeFont(type_title, title_font, color_title, subtitle_font, color_subtitle, subsubtitle_font, color_subsubtitle):
	var dynamic_font = DynamicFont.new()
	#Title creation
	if (type_title ==1):
		dynamic_font.size = 64
		dynamic_font.font_data = load(title_font)
		_Label.add_font_override("font", dynamic_font)
		_Label.set("custom_colors/font_color",color_title)
	#Subtitle creation
	if (type_title ==2):
		dynamic_font.size = 45
		dynamic_font.font_data = load(subtitle_font)
		_Label.add_font_override("font", dynamic_font)
		_Label.set("custom_colors/font_color",color_subtitle)
	#Sub subtitle creation
	if (type_title ==3):
		dynamic_font.size = 32
		dynamic_font.font_data = load(subsubtitle_font)
		_Label.add_font_override("font", dynamic_font)
		
		_Label.modulate = color_subsubtitle
	print(_Label.get("custom_colors/font_color"))
	var size = _Label.get_font("font").get_string_size(_Label.text)
	
	_Label.rect_size = Vector2(size.x, size.y)
	createLabel()
