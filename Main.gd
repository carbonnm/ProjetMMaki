extends Node2D

onready var _background := $Background
onready var _camera := $Camera2D
onready var _lines := $Lines

onready var RCC := $RightClickContainer

var _pressed := false
var _current_line: Line2D
var zoom_speed:Vector2 = Vector2(0.1,0.1)
var zoom_step = 1.1 # speed of the zoom

func _input(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom and unzoom
			var mouse_position = event.position
			# zoom
			if event.button_index == BUTTON_WHEEL_UP:
#				if zoom > zoom_min:
				zoom_at_point(1/zoom_step,mouse_position)
			# unzoom
			if event.button_index == BUTTON_WHEEL_DOWN:
#				if zoom < zoom_max:
				zoom_at_point(zoom_step,mouse_position)
				
			# Create a new Line2D on left click
			if event.button_index == BUTTON_LEFT:
				# Delete the previous line if it didn't have any points.
				if _current_line != null:
					if _current_line.points.size() == 0:
						_current_line.queue_free()
				
				_current_line = Line2D.new()
				# The camera zoom is always the same value on each axis, so 
				# we'll use x for ease of use
				_current_line.width = 10.0 * _camera.zoom.x
				_current_line.default_color = RCC.color
				_lines.add_child(_current_line)
			
	# Draw the lines at the position of the mouse
	if event is InputEventMouseMotion && RCC.visible == false:
		if event.button_mask == BUTTON_MASK_LEFT:
			_current_line.add_point(get_global_mouse_position())
		
	# Move the camera position relative to where the event input happen
	if event is InputEventMouseMotion:
		if event.button_mask == BUTTON_MASK_MIDDLE:
			_camera.position -= event.relative * _camera.zoom
			_background.position = _camera.position
	

func _process(delta):
#	_background.rect_size = get_viewport_rect().size * _camera.zoom
	var Cam_relative_position:Vector2 = get_viewport_rect().size * _camera.zoom
	_background.region_rect = Rect2(0, 0, Cam_relative_position.x, Cam_relative_position.y)

func zoom_at_point(zoom_change, point):
	var pos0:Vector2 = _camera.global_position # camera position
	var viewport0:Vector2 = get_viewport().size # viewport size
	var pos1:Vector2  # next camera position
	var zoom0:Vector2 = _camera.zoom # current zoom value
	var zoom1:Vector2 = zoom0 * zoom_change # next zoom value
	
	pos1 = pos0 + (-0.5*viewport0 + point) * (zoom0 - zoom1)
	_camera.zoom = zoom1
	_camera.global_position = pos1
	_background.global_position = _camera.global_position
