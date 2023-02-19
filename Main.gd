extends Node2D

signal Line_count(counter)

var LINE := preload("res://Scripts/Line.gd")

onready var _background := $Background
onready var _camera := $Camera2D
onready var _lines := $Lines
onready var _action_menu := $ActionMenu

onready var RCC := $RightClickContainer

const ZOOMMIN = Vector2(0.01,0.01)
const ZOOMMAX = Vector2(10000,10000)
var linewidth: float = 4.0

var _pressed := false
var _current_line
var zoom_speed:Vector2 = Vector2(0.1,0.1)
var zoom_step = 1.1 # speed of the zoom
var selected_lines : Array
var Drawing_mode : bool = true
var Select_mode : bool = false
var Select_rect : Area2D

var Modes = {
	"Drawing": true,
	"Select": false
}

func _on_Background_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if RCC.visible == true:
			RCC.hide()
			
		if event.is_pressed():
			
			Zoom_UnZoom(event)
			
			# Create a new Line2D on left click
			if event.button_index == BUTTON_LEFT :
				if Modes.Drawing:
					# Delete the previous line if it didn't have any points or less than 2.
					# less than 2 because a bug could occure if you spam left click on a laptop
					if _current_line != null and is_instance_valid(_current_line):
						if _current_line._line.points.size() <= 2:
							_current_line.queue_free()
						
					_current_line = LINE.new()
					_lines.add_child(_current_line)
					_current_line.set_params(linewidth * _camera.zoom.x, RCC.color, get_global_mouse_position())
					_current_line.add_point(get_global_mouse_position())
					
					emit_signal("Line_count",_lines.get_child_count())
				
				elif  Modes.Select:
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
		if !event.pressed:
			if Modes.Select :
				Select_rect.queue_free()
				
	# Draw the lines or move the camera
	if event is InputEventMouseMotion: 
		if event.button_mask == BUTTON_MASK_LEFT:
			# move the camera position relative to where the event input happen if Key_alt
			# is pressed (to work with laptop pads)
			if event.alt :
				_camera.position -= event.relative * _camera.zoom
				_background.rect_global_position = _camera.global_position - (Vector2(512,300) * _camera.zoom) 
			# Draw the line at the position
			elif Modes.Drawing :
				_current_line.add_point(get_global_mouse_position())
			elif Modes.Select:
				if Select_rect != null:
					var pos1 = Select_rect.global_position
					var pos2 = get_global_mouse_position()
					var center = ((pos2 - pos1) / 2)
					
					Select_rect.get_child(0).position = center
					Select_rect.get_child(0).shape.extents = ((pos2 - pos1) / 2)
					
					Select_rect._size = pos2 - pos1
					Select_rect.update()
					
		# Move the camera position relative to where the event input happen
		if event.button_mask == BUTTON_MASK_MIDDLE:
			_camera.position -= event.relative * _camera.zoom
			_background.rect_position = _camera.position - (Vector2(512,300) * _camera.zoom)

func zoom_at_point(zoom_change, point):
	var pos0:Vector2 = _camera.global_position # camera position
	var viewport0:Vector2 = get_viewport().size # viewport size
	var pos1:Vector2  # next camera position
	var zoom0:Vector2 = _camera.zoom # current zoom value
	var zoom1:Vector2 = zoom0 * zoom_change # next zoom value
	
	pos1 = pos0 + (-0.5*viewport0 + point) * (zoom0 - zoom1)
	_camera.zoom = zoom1
	_camera.global_position = pos1
	# on prend la pos de la camera ( au centre de la fenetre) et on l'offset en haut à gauche 
	# Vector2(512,300) car c'est la moitié de la taille interne de l'application
	_background.rect_global_position = _camera.global_position - (Vector2(512,300) * _camera.zoom) 
	_background.rect_size = Vector2(1024,600) * _camera.zoom

func _on_Selection_pressed() -> void:
	Change_mode("Select")

func _on_Drawing_pressed() -> void:
	Change_mode("Drawing")
	DrawLineContainer(false)

func Change_mode(_mode:String) -> void:
	for mode in Modes:
		# Modes[mode] = mode == _mode
		if mode == _mode:
			Modes[mode] = true
		else:
			Modes[mode] = false

func RetrieveArea(areas:Array):
	selected_lines = areas.duplicate()
	DrawLineContainer(true)
	if selected_lines.size() != 0:
		_action_menu.show()

func DrawLineContainer(drawing:bool):
	for line in selected_lines:
		# lancer la fonction _draw setup dans Line.gd
		line.draw = drawing
		# lance la fonction draw() de godot (update() lance draw())
		line.update()

# delete les ligne selectionnées
func _on_Delete_pressed():
	for area in selected_lines:
		area.queue_free()
	selected_lines.clear()
	_action_menu.hide()
#zoom and unzoom with the camera at the pos of the mouse
func Zoom_UnZoom(event):
	var mouse_position = event.position
	
	# zoom
	if event.button_index == BUTTON_WHEEL_UP:
		if _camera.zoom > ZOOMMIN:
			zoom_at_point(1/zoom_step,mouse_position)
	# unzoom
	if event.button_index == BUTTON_WHEEL_DOWN:
		if _camera.zoom < ZOOMMAX:
			zoom_at_point(zoom_step,mouse_position)
