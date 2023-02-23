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
	"DragAndDrop": false
}

func _ready() -> void:
	_camera.connect("zoom_changed", self, "UpdateBackground")
	#Canvas name recuperation
#	var canvas_name = SceneSwitcher.get_param("namecanvas")
	#Canvas font colors recuperation
#	var color_title = SceneSwitcher.get_param("titlecolor")
#	var color_subtitle = SceneSwitcher.get_param("subtitlecolor")
#	var color_subsubtitle = SceneSwitcher.get_param("subsubtitlecolor")
	#test :print(color_title,color_subtitle,color_subsubtitle)




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
					Drag_and_Drop()
							
		else:
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
				_current_line.add_point(get_global_mouse_position())
			elif Modes.Select:
				UpdateSelectionArea()
			# Check if any selected lines exist
			elif Modes.DragAndDrop:
				if selected_lines.size() > 0:
					Drag_and_Drop()
					# Loop through all selected lines
#					for area in selected_lines:
						# Get the mouse position relative to the selected line's parent node
#						var mouse_pos = _lines.to_local(get_global_mouse_position())						
						# Move the selected line to the new position
#						area.position = get_global_mouse_position()							
						# Update the line's position
#						area.update()
				
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


func DrawLine():
	# Delete the previous line if it didn't have any points or less than 2.
	# less than 2 because a bug could occure if you spam left click on a laptop
	if _current_line != null and is_instance_valid(_current_line):
		if _current_line._line.points.size() <= 2:
			_current_line.queue_free()
		
	_current_line = LINE.new()
	_current_line.position = get_global_mouse_position() 
	_lines.add_child(_current_line)
	_current_line.set_params(linewidth * _camera.zoom.x, RCC.color, get_global_mouse_position())
	_current_line.add_point(get_global_mouse_position())
	
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

	
func _on_Drag_And_Drop_pressed():
	Change_mode("DragAndDrop")
	_action_menu.hide()
	
func Drag_and_Drop():
	for area in selected_lines:
		area.position = get_global_mouse_position()
