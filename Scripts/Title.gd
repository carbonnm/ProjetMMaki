class_name Title extends Area2D

var _rtl : RichTextLabel
var c_shape: CollisionShape2D
var shape: RectangleShape2D
var zoom:Vector2

var draw:bool = false

func _ready() -> void:
	_rtl = RichTextLabel.new()
	_rtl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	self.add_child(_rtl)

func set_params(bbcode_enabled, chosen_title, size_rtl, position_rtl):
	_rtl.bbcode_enabled = bbcode_enabled
	_rtl.bbcode_text = chosen_title
#	_rtl.rect_size = size_rtl
	_rtl.rect_global_position = position_rtl
#	_rtl.fit_content_height

## create a collision shape for each point in the line
#func CreateCollisions():	
#	HitBoxs.clear()
#	HitBoxs.append(Create_Shape(_line.points[index], _line.points[index+1]))

# create the shape
func Create_Shape():
	c_shape = CollisionShape2D.new()
	shape = RectangleShape2D.new()
	
	var center = _rtl.rect_position + Vector2(_rtl.rect_size.x/2, _rtl.rect_size.y/2)
	center.x -= 8
	c_shape.position = center
	
	shape.extents = _rtl.rect_size / 2
	shape.extents.x -= 8
	c_shape.shape = shape
	
	self.add_child(c_shape)

	
func _draw() -> void:
	if draw:
#		var corners = get_line2D_corner()
#		var upper_left = corners[0]
#		var bottom_down = corners[1]
		draw_rect(Rect2(_rtl.rect_position, _rtl.rect_size), Color.aqua, false, 4)



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
func get_rtl_center():
	print(_rtl.rect_global_position + Vector2(_rtl.rect_size.x/2, _rtl.rect_size.y/2))
	print(_rtl.rect_global_position)
	return (_rtl.rect_global_position + Vector2(_rtl.rect_size.x/2, _rtl.rect_size.y/2))

"""
Centers position of the Area2D at the center of the line.
"""
func center_area2D_to_center():
	
	var rtl_center = self.get_rtl_center()
	self.position += rtl_center
	_rtl.rect_global_position -= rtl_center
	self._rtl = _rtl
#	var line_center = self.get_line2D_center()
#	self.position += line_center
#
#	for index in range(line_points.size()):
#		line_points[index] -= line_center
#
#	self._line.points = line_points



func createRTL():
	self.center_area2D_to_center()
	print("here")
	self.Create_Shape()

func ChangeFont(type_title, title_font, color_title, subtitle_font, color_subtitle, subsubtitle_font, color_subsubtitle):
	var dynamic_font = DynamicFont.new()
	#Title creation
	if (type_title ==1):
		dynamic_font.size = 64
		dynamic_font.font_data = load(title_font)
		_rtl.add_font_override("normal_font", dynamic_font)
		_rtl.set("custom_colors/default_color",color_title)
	#Subtitle creation
	if (type_title ==2):
		dynamic_font.size = 45
		dynamic_font.font_data = load(subtitle_font)
		_rtl.add_font_override("normal_font", dynamic_font)
		_rtl.set("custom_colors/default_color",color_subtitle)
	#Sub subtitle creation
	if (type_title ==3):
		dynamic_font.size = 32
		dynamic_font.font_data = load(subsubtitle_font)
		_rtl.add_font_override("normal_font", dynamic_font)
		_rtl.set("custom_colors/default_color",color_subsubtitle)
	
	var size = _rtl.get_font("normal_font").get_string_size(_rtl.text)
	
	_rtl.rect_size = Vector2(size.x + 16, size.y + 4)
	createRTL()
