extends Node2D

signal Line_count(counter)

var LINE := preload("res://Scripts/Line.gd")

onready var _background := $Background
onready var _camera := $Camera
onready var _lines := $Lines
onready var _action_menu := $ActionMenu

onready var RCC := $RightClickContainer

var linewidth: float = 4.0

var _current_line
var selected_lines : Array
var Select_rect : Area2D

var Modes = {
	"Drawing": true,
	"Select": false,
	"DragAndDrop": false,
	"Rescale": false,
	"Rotate": false
}

func _ready() -> void:
	_camera.connect("zoom_changed", self, "UpdateBackground")
	#Canvas name recuperation
	var canvas_name = SceneSwitcher.get_param("namecanvas")
	#Canvas font colors recuperation
	var color_title = SceneSwitcher.get_param("titlecolor")
	var color_subtitle = SceneSwitcher.get_param("subtitlecolor")
	var color_subsubtitle = SceneSwitcher.get_param("subsubtitlecolor")
	
	#Retrieves chosen font(s) for Title, Subtitle, Sub-subtitle
	#var titlefont : SceneSwitcher.get_param("titlefont")
	#var subtitlefont : SceneSwitcher.get_param("subtitlefont")
	#var subsubtitlefont : SceneSwitcher.get_param("subsubtitlefont")
	
	#Canvas background color recuperation (fixing the background bug)
	var color_background
	if not (SceneSwitcher.get_param("backgroundcolor")):
		color_background = Color( 0.980392, 0.921569, 0.843137, 1 )
	else:
		color_background = SceneSwitcher.get_param("backgroundcolor")
	
	#sets the background color of the canvas to the chosen one in the menu
	get_node("BackgroundColored").color = color_background

#Function to test the title addition (don't erase please)	
func _input(ev):
	if ev is InputEventKey and ev.scancode == KEY_K:
		
		get_node("Titlemenuaddition").visible = true


func _on_Background_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		RCC.visible = RCC.visible == true
			
		if event.is_pressed():
			_camera.ManageInput(event)
			
			# Create a new Line2D on left click
			if event.button_index == BUTTON_LEFT:
				if Modes.Drawing:
					DrawLine()
				elif Modes.Select:
					DrawSelectionArea()
				elif Modes.DragAndDrop:
					var selected = true
		else:
			if event.button_index == BUTTON_LEFT:
				if Modes.Drawing:
					Curve2D_Transformer()
			if Modes.Select:
				Select_rect.queue_free()
	
	# Draw the lines or move the camera
	if event is InputEventMouseMotion: 
		if event.button_mask == BUTTON_MASK_LEFT:
			# move the camera position relative to where the event input happen if Key_alt
			# is pressed (to work with laptop pads)
			if event.alt:
				DragCamera(event.relative)
				return
			
			# Draw the line at the position
			if Modes.Drawing:
				_current_line._line.add_point(get_global_mouse_position())
			elif Modes.Select:
				UpdateSelectionArea()
			# Check if any selected lines exist
			elif Modes.DragAndDrop:
				if selected_lines.size() > 0:
					Drag_and_Drop(event.relative)
			elif Modes.Rescale:
				#Check if the selection if greater than 0. 
				print(selected_lines.size())
				if selected_lines.size() > 0:
					Rescale()
			elif Modes.Rotate:
				if selected_lines.size() > 0:
					Rotate()
				
		# Move the camera position relative to where the event input happen
		if event.button_mask == BUTTON_MASK_MIDDLE:
			DragCamera(event.relative)
			
	
func _on_Selection_pressed() -> void:
	Change_mode("Select")

func _on_Drawing_pressed() -> void:
	Change_mode("Drawing")
	DrawLineContainer(false)

func Change_mode(_mode:String) -> void:
	for mode in Modes:
		Modes[mode] = mode == _mode

func RetrieveArea(areas:Array):
	selected_lines = areas.duplicate()
	DrawLineContainer(true)
	if selected_lines.size() != 0:
		_action_menu.show()

func DrawLineContainer(drawing:bool):
	for line in selected_lines:
		# lancer la fonction _draw setup dans Line.gd
		line[0].draw = drawing
		# lance la fonction draw() de godot (update() lance draw())
		line[0].update()

# delete les ligne selectionnées
func _on_Delete_pressed():
	for area in selected_lines:
		area.queue_free()
	selected_lines.clear()
	_action_menu.hide()

func DrawLine():
	# Delete the previous line if it didn't have any points or less than 2.
	# less than 2 because a bug could occure if you spam left click on a laptop
	if _current_line != null and is_instance_valid(_current_line):
		if _current_line._line.points.size() <= 2:
			_current_line.queue_free()
		
	_current_line = LINE.new()
	_lines.add_child(_current_line)
	_current_line.set_params(linewidth * _camera.zoom.x, RCC.color, _camera.zoom)
	_current_line._line.add_point(get_global_mouse_position())
	
	emit_signal("Line_count",_lines.get_child_count())

func DrawSelectionArea():
	Select_rect = Area2D.new()
	Select_rect.set_script(load("res://Scripts/Selector.gd"))
	Select_rect.connect("SendArea", self, "RetrieveArea")
	self.add_child(Select_rect)
	
	DrawLineContainer(false)
	
	var c_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	c_shape.shape = shape
	shape.extents = Vector2.ZERO
	Select_rect.add_child(c_shape)
	
	Select_rect.position = get_global_mouse_position()

func UpdateSelectionArea():
	if Select_rect != null:
		var pos1 = Select_rect.global_position
		var pos2 = get_global_mouse_position()
		var center = ((pos2 - pos1) / 2)
		
		Select_rect.get_child(0).position = center
		Select_rect.get_child(0).shape.extents = ((pos2 - pos1) / 2)
		
		Select_rect._size = pos2 - pos1
		Select_rect.update()

func UpdateBackground():
	# on prend la pos de la camera ( au centre de la fenetre) et on l'offset en haut à gauche 
#	# Vector2(512,300) car c'est la moitié de la taille interne de l'application
	_background.rect_global_position = _camera.global_position - (Vector2(512,300) * _camera.zoom) 
	_background.rect_size = Vector2(1024,600) * _camera.zoom

func DragCamera(Relative:Vector2):
	_camera.position -= Relative
	# Sync background with camera
	_background.rect_global_position = _camera.global_position - (Vector2(512,300) * _camera.zoom)


"""
Change mode to Drag and drop when drag
"""
func _on_Drag_And_Drop_pressed():
	Change_mode("DragAndDrop")
	_action_menu.hide()

	
func Drag_and_Drop(relative):
	for area in selected_lines:
		area[0].position += relative


"""
Change mode to Rescale when rescale button pressed.
"""
func _on_Rescale_pressed():
	Change_mode("Rescale")
	_action_menu.hide()


"""
Rescale the selected area (zoom/dezoom)
"""
func Rescale():
	var center = Vector2.ZERO
	for indexed_area2D in selected_lines:
		center += indexed_area2D[0].position
	center = center/selected_lines.size()
	
	print(center)
	for area in selected_lines:
		print(area[0].position)
		print(get_line2D_center(area[0]._line))
		if get_global_mouse_position() >= center :
			area[0].scale += Vector2(0.03, 0.03)
		elif get_global_mouse_position() <= center :
			area[0].scale -= Vector2(0.03, 0.03)
		

"""
Change mode to Rotate when rotation button pressed
"""
func _on_Rotation_pressed():
	Change_mode("Rotate")
	_action_menu.hide()
	
"""
Rotate the selected object
"""
func Rotate():
	var rotation_speed = deg2rad(1)
	var radius:float
	var center = Vector2.ZERO
	
	for indexed_area2D in selected_lines:
		center += indexed_area2D[0].position
	center = center/selected_lines.size()
	
	var angle:float
	var coord:Vector2
	
	var area2D:Area2D
	for indexed_area in selected_lines:
		area2D = indexed_area[0]
		angle = fmod(area2D.position.angle_to_point(center)+rotation_speed,deg2rad(360))
		radius = area2D.position.distance_to(center)
		coord = Vector2(cos(angle),sin(angle))*radius + center
		
		area2D.position = coord
		area2D.rotation += rotation_speed


# change the point in the ligne to make it more smooth by using an algorithm
func Curve2D_Transformer():
	var curve = Curve2D.new()
	curve.bake_interval = 16.0 * _camera.zoom.x
	for point in _current_line._line.points:
		curve.add_point(point)
	var new_points = curve.get_baked_points()

	var line_center = get_line2D_center(_current_line._line)

	_current_line.position += line_center
	
	for index in range(new_points.size()):
		new_points[index] -= line_center
	
	_current_line._line.points = new_points
	
	curve = null
	_current_line.CreateCollisions()


func _on_Copy_pressed():
	print("copy")
	var copied = selected_lines.duplicate()
	_action_menu.hide()

"""
Marie : Code qui marche pour juste une image
if Input.is_action_pressed("Copy"):
		print("paste")
elif Input.is_action_just_pressed("Paste"):
	var newNode = $Icon.duplicate()
	newNode.position = get_global_mouse_position()
	add_child(newNode)
"""

func _on_Paste_pressed():
	_action_menu.hide()
	"""
	var copied = selected_lines.duplicate()
	for area in copied:
		area[0].position = get_global_mouse_position()
		add_child(area[0])
	"""
	"""
	for area in selected_lines:
		var copiedLine = area[0].duplicate()
		copiedLine.position = get_global_mouse_position()
		add_child(copiedLine)
	"""
	print(selected_lines)
	for area in selected_lines:
		print(area)
		print(area[0])
		var duplarea0 = area[0].duplicate()
		duplarea0.position = get_global_mouse_position()
		_lines.add_child(duplarea0)



func line_selection_center(indexed_list_of_area2D):
	var center:Vector2
	var current_area2D_center:Vector2
	var area2D:Area2D
	var line2D:Line2D
	
	for indexed_area2D in selected_lines:
		area2D = indexed_area2D[0]
		line2D = get_child_of_type(area2D,"Line2D")
		current_area2D_center = get_line2D_center(line2D)
		center += current_area2D_center
	
	return center/selected_lines.size()
	
func get_child_of_type(node, type):
	var num_of_child = node.get_child_count()
	for i in range(num_of_child):
		var child = node.get_child(i)
		if child.is_class(type):
			return child
			
func get_line2D_center(line2D):
	var point_pos:Vector2
	var center = Vector2.ZERO
	for index in range(line2D.get_point_count()):
		point_pos = line2D.get_point_position(index)
		center += point_pos
		
	center = center/line2D.get_point_count()
	
	return center

	
