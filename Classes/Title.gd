class_name Title extends Area2D

var _TextEdit : TextEdit
var c_shape: CollisionShape2D
var shape: RectangleShape2D
var zoom:Vector2

var stylebox_empty := StyleBoxEmpty.new()


var draw:bool = false

func _ready() -> void:
	_TextEdit = TextEdit.new()
	_TextEdit.get_child(0).add_stylebox_override("scroll", stylebox_empty)
	_TextEdit.get_child(1).add_stylebox_override("scroll", stylebox_empty)
	_TextEdit.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# code pour change le background de TextEdit
	_TextEdit.add_stylebox_override("normal", stylebox_empty)
	
	self.add_child(_TextEdit)

func set_params(bbcode_enabled, chosen_title, size_TextEdit, position_TextEdit):
#	_TextEdit.bbcode_enabled = bbcode_enabled
	_TextEdit.text = chosen_title
#	_TextEdit.rect_size = size_TextEdit
	_TextEdit.rect_global_position = position_TextEdit
#	_TextEdit.fit_content_height
	

## create a collision shape for each point in the line
#func CreateCollisions():	
#	HitBoxs.clear()
#	HitBoxs.append(Create_Shape(_line.points[index], _line.points[index+1]))

# create the shape
func Create_Shape():
	c_shape = CollisionShape2D.new()
	shape = RectangleShape2D.new()
	
	var center = _TextEdit.rect_position + Vector2(_TextEdit.rect_size.x/2, _TextEdit.rect_size.y/2)
	
#	center.x -= 8
	c_shape.position = center
	
	shape.extents = _TextEdit.rect_size / 2
#	shape.extents.x -= 8
	c_shape.shape = shape
	
	self.add_child(c_shape)

	
func _draw() -> void:
	if draw:
#		var corners = get_line2D_corner()
#		var upper_left = corners[0]
#		var bottom_down = corners[1]
		draw_rect(Rect2(_TextEdit.rect_position, _TextEdit.rect_size), Color.aqua, false, 4)



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
func get_TextEdit_center():
	return (_TextEdit.rect_global_position + Vector2(_TextEdit.rect_size.x/2, _TextEdit.rect_size.y/2))

"""
Centers position of the Area2D at the center of the line.
"""
func center_area2D_to_center():
	var TextEdit_center = self.get_TextEdit_center()
	
	self.position = TextEdit_center
	_TextEdit.rect_global_position -= TextEdit_center
	
	self._TextEdit = _TextEdit
#	var line_center = self.get_line2D_center()
#	self.position += line_center
#
#	for index in range(line_points.size()):
#		line_points[index] -= line_center
#
#	self._line.points = line_points



func createTextEdit():
	self.center_area2D_to_center()
	self.Create_Shape()

func ChangeFont(type_title, title_font, color_title, subtitle_font, color_subtitle, subsubtitle_font, color_subsubtitle):
	var dynamic_font = DynamicFont.new()
	#Title creation
	if (type_title ==1):
		dynamic_font.size = 64
		dynamic_font.font_data = load(title_font)
		_TextEdit.add_font_override("font", dynamic_font)
		_TextEdit.set("custom_colors/font_color",color_title)
	#Subtitle creation
	if (type_title ==2):
		dynamic_font.size = 45
		dynamic_font.font_data = load(subtitle_font)
		_TextEdit.add_font_override("font", dynamic_font)
		_TextEdit.set("custom_colors/font_color",color_subtitle)
	#Sub subtitle creation
	if (type_title ==3):
		dynamic_font.size = 32
		dynamic_font.font_data = load(subsubtitle_font)
		_TextEdit.add_font_override("font", dynamic_font)
		_TextEdit.set("custom_colors/font_color",color_subsubtitle)
	
	var size = _TextEdit.get_font("font").get_string_size(_TextEdit.text)
	
	_TextEdit.rect_size = Vector2(size.x, size.y)
	createTextEdit()
