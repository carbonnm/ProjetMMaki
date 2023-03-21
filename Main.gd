class_name Canvas
extends Node2D

#signal Line_count(counter)

var LINE := preload("res://Scripts/Line.gd")
var RTL := preload("res://Scripts/Title.gd")
var AREASELECTION := preload("res://Scripts/AreaSelection.gd")

var DragAndDrop := preload("res://Scripts/Modes/DragAndDrop.gd").new()
var Rescale := preload("res://Scripts/Modes/Rescale.gd").new()
var Rotation := preload("res://Scripts/Modes/Rotation.gd").new()


var Utils := preload("res://Scripts/Utilities/Utilities.gd").new()
var Mimic := preload("res://Scripts/Utilities/BuiltInMimic.gd").new()

onready var _background := $BackgroundColored
onready var _camera := $Camera
onready var _lines := $Lines
onready var _linecounter := get_node("CanvasLayer/HBoxContainer/LinesCounter")
onready var _rightclick := $RightClickContainer
onready var _action_menu := $ActionMenu

onready var RCC := $CanvasLayer/Panel2/VBoxContainer

onready var _pm = $PopupMenu

var linewidth: float = 4.0

var _current_line : Area2D
var selected_lines : Array
var Select_rect : Area2D
var copy_lignes : Array
var Selection_area : Area2D

#lists and variables used for undo (ctr+Z), redo (ctrl+Y)
var created_elements : Array 
var deleted : Array
var moved : Array
var rescaled : Array
var rotated : Array
var commands : Array
var index_deleted = 0
var index_moved = 0
var index_rotated = 0
var index_created = 0
var index_rescaled = 0
var index_command = 0
var notyetundo = true

#verifies if a movement (with alt/ the middle mouse button has been done for placing the color picker)
var notyetmoved = true

#global variables added for default options (making testing from the Main.tscn possible without crash)
#they should be deleted when the program is finished
var title_font
var subtitle_font 
var subsubtitle_font
var color_title 
var color_subtitle  
var color_subsubtitle 

var copied_lines: Array

onready var states = $StateManager

func _ready() -> void:
	states.init(self)
	
	index_created = created_elements.size()
	index_command = commands.size()
	index_deleted = deleted.size()
	
	_camera.connect("zoom_changed", self, "UpdateBackground")
	_rightclick.connect("_on_RightClickContainer_undo", self,"_on_RightClickContainer_undo")
	#connects the signal on new title input 
	#and calls the function taking care of effectively creating it 
	get_node("Titlemenuaddition").connect("new_title", self, "create_new_title")
	
	#Canvas name recuperation
	var canvas_name = SceneSwitcher.get_param("namecanvas")
	#Canvas font colors recuperation
	color_title = SceneSwitcher.get_param("titlecolor")
	color_subtitle = SceneSwitcher.get_param("subtitlecolor")
	color_subsubtitle = SceneSwitcher.get_param("subsubtitlecolor")
	#code for testing (avoid main.tscn crash if you don't go from homepage)
	if not(color_title) and not(color_subtitle) and not(color_subsubtitle):
		color_title = Color( 0, 0, 0, 1 ) 
		color_subtitle = Color( 0, 0, 0, 1 ) 
		color_subsubtitle = Color( 0, 0, 0, 1 ) 
	
	
	#Retrieves chosen font(s) for Title, Subtitle, Sub-subtitle
	title_font =  SceneSwitcher.get_param("titlefont")
	subtitle_font = SceneSwitcher.get_param("subtitlefont")
	subsubtitle_font = SceneSwitcher.get_param("subsubtitlefont")
	#code for testing (avoid main.tscn crash if you don't go from homepage)
	if not(title_font) and  not(subtitle_font) and  not(subsubtitle_font):
		title_font = "res://Assets/Fonts/arial_narrow_7.ttf"
		subtitle_font = "res://Assets/Fonts/arial_narrow_7.ttf"
		subsubtitle_font = "res://Assets/Fonts/arial_narrow_7.ttf"
		
	#Canvas background color recuperation (fixing the background bug)
	var color_background 
	#code for testing (avoid main.tscn crash if you don't go from homepage)
	if not (SceneSwitcher.get_param("backgroundcolor")):
		color_background = Color( 0.980392, 0.921569, 0.843137, 1 )
	else:
		color_background = SceneSwitcher.get_param("backgroundcolor")
	
	#sets the background color of the canvas to the chosen one in the menu
	get_node("BackgroundColored").color = color_background


#Creates the new richtextlabel node with the new wanted title
func create_new_title(chosen_title):
	get_node("Titlemenuaddition").visible = false
	
	#position of the title is the same as the title menu addition 
	#which was set from the retrieved position of the right-click
	
	var rtl = RTL.new()
	var x_pos_title = get_node("Titlemenuaddition").position.x 
	var y_pos_title = get_node("Titlemenuaddition").position.y 
	var rtl_position = Vector2(x_pos_title, y_pos_title)
	get_node("Lines").add_child(rtl)
	rtl.set_params(true, str(chosen_title), Vector2(500, 100), rtl_position)

	
	var type_title = get_node("Titlemenuaddition").type_title
	rtl.ChangeFont(type_title, title_font, color_title, subtitle_font, color_subtitle, subsubtitle_font, color_subsubtitle)
	
	created_elements.append(rtl)
	commands.append("creation")
	index_created +=1
	index_command +=1
	print(created_elements,_lines.get_child_count())
		


func _on_Background_gui_input(event: InputEvent) -> void:
	_unhandled_input(event)
	if event is InputEventMouseButton:
		RCC.visible = RCC.visible == true
		if Modes.MoveCanvas:
			_on_Move_Canvas_button(event)
			Input.set_custom_mouse_cursor(load("res://Assets/Graphics/Image/hand-regular.svg"))	
		if event.is_pressed():
			_camera.ManageInput(event)
			
	# Draw the lines or move the camera
	if event is InputEventMouseMotion: 
		if event.button_mask == BUTTON_MASK_LEFT:
			# move the camera position relative to where the event input happen if Key_alt
			# is pressed (to work with laptop pads)
			if event.alt:
				DragCamera(event.relative)
				notyetmoved = false
				return
				
		# Move the camera position relative to where the event input happen
		if event.button_mask == BUTTON_MASK_MIDDLE:
			notyetmoved = false
			DragCamera(event.relative)

func _unhandled_input(event: InputEvent) -> void:
	states.input(event)


"""
Draw a line to make a container around the selected lines
Parameters :
---------------
drawing : bool -> launch draw function if true
"""
func DrawLineContainer(drawing:bool):
	if drawing :
		Selection_area = AREASELECTION.new()
		get_node("Lines").add_child(Selection_area)
#
		var corners = get_selection_area_corner()
		var upper_left = corners[0]
		var bottom_right = corners[1]
		var area_size = get_position_area_size()
		var min_x = area_size[0]
		var min_y = area_size[1]
		
		var area_size_vec = Vector2(bottom_right[0], bottom_right[1])
		var size_x = bottom_right[0] * 2
		var size_y = bottom_right[1] * 2
		var area_position = Vector2(min_x, min_y)
		#print("position", area_position)
		
		Selection_area.position = Vector2(min_x, min_y)
	
		Selection_area.set_params(min_x, min_y, size_x, size_y)
		#Selection_area.draw = drawing
		#Selection_area.update()
		
	


"""
Calls DrawLineContainer whith the drawing bool to true
"""
func RetrieveArea(areas:Array):

	selected_lines = areas.duplicate()
	DrawLineContainer(true)
	if selected_lines.size() != 0:
		_action_menu.show()


"""
Gets the corner of the selection_area
Returns : Array  
"""
func get_selection_area_corner() :
	var upper_left = Vector2.INF
	var bottom_right = -1 * Vector2.INF
	for element in selected_lines : 
		if element[0] is Stroke :
			for point in element[0]._line.points:
				if Vector2(min(upper_left.x,point.x),min(upper_left.y,point.y)) < upper_left :
					upper_left = Vector2(min(upper_left.x,point.x),min(upper_left.y,point.y))
				if Vector2(max(bottom_right.x,point.x),max(bottom_right.y,point.y)) > bottom_right :
					bottom_right = Vector2(max(bottom_right.x,point.x),max(bottom_right.y,point.y))
	return [upper_left,bottom_right]
		
"""
Gets the size of the selection_area 
Returns : Vector2 
	- min_x : x coordinates of the selection area
	- min_y : y coordinates of the selection area 
"""
func get_position_area_size() -> Array :
	var min_x
	var min_y
	var coord_x
	var coord_y
	for element in selected_lines :
		min_x = element[0].position.x
		min_y = element[0].position.y
	for element in selected_lines :
		if element[0] is Stroke :
			for point in element[0]._line.get_point_count():
				coord_x = element[0].position.x + element[0]._line.get_point_position(point).x
				coord_y = element[0].position.y + element[0]._line.get_point_position(point).y
				if coord_x < min_x :
					min_x = coord_x
				if coord_y < min_y :
					min_y = coord_y
	return [min_x, min_y]
			

"""
Draw the geometrical selection area around the selected lines 
Calls DrawLineContainer()
Is called when select button is pressed
"""
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
	

"""
Update of the selection area
Is called when we move the camera 
"""
func UpdateSelectionArea():
	if Select_rect != null:
		var pos1 = Select_rect.global_position
		var pos2 = get_global_mouse_position()
		var center = ((pos2 - pos1) / 2)
		
		Select_rect.get_child(0).position = center
		Select_rect.get_child(0).shape.extents = ((pos2 - pos1) / 2)
		
		Select_rect._size = pos2 - pos1
		Select_rect.update()


func DrawLine():
	# Delete the previous line if it didn't have any points or less than 2.
	# less than 2 because a bug could occure if you spam left click on a laptop
	if _current_line != null and is_instance_valid(_current_line):
		if _current_line._line.points.size() <= 2:
			_current_line.queue_free()
		
	_current_line = LINE.new()
	_lines.add_child(_current_line)
	_current_line.Setup()
	_current_line.set_params(linewidth * _camera.zoom.x, RCC.color, _camera.zoom)
	_current_line._line.add_point(get_global_mouse_position())
	if _current_line:
		#need to replicate the "if" after drawing finished otherwise,
		# empty lines are added to created_elements
		created_elements.append(_current_line)
		commands.append("creation")
		index_created+=1
		index_command+=1
	
	print(created_elements,_lines.get_child_count())
	_linecounter.Count = str(_lines.get_child_count())
	#emit_signal("Line_count",_lines.get_child_count())
	


func UpdateBackground():
	# on prend la pos de la camera ( au centre de la fenetre) et on l'offset en haut à gauche 
#	# Vector2(512,300) car c'est la moitié de la taille interne de l'application
	_background.rect_global_position = _camera.global_position - (Vector2(512,300) * _camera.zoom) 
	_background.rect_size = Vector2(1024,600) * _camera.zoom

func DragCamera(Relative:Vector2):
	_camera.position -= Relative
	# Sync background with camera
	_background.rect_global_position = _camera.global_position - (Vector2(512,300) * _camera.zoom)

func _on_Create_annotation_pressed():
	pass # Replace with function body.


func _on_Group_items_pressed():
	pass # Replace with function body.


func _on_Save_canvas_pressed():
	pass # Replace with function body.


enum PopupIds {
	CREATE_TITLE = 1
	CREATE_SUBTITLE = 2
	CREATE_SUB_SUBTITLE = 3
	
	WRITING_DRAWING = 4
	WRITING = 5
}


func _on_Create_text_pressed():
	_pm.clear()
	_pm.add_item("Créer titre", PopupIds.CREATE_TITLE)
	_pm.add_item("Créer sous-titre", PopupIds.CREATE_SUBTITLE)
	_pm.add_item("Créer sous sous-titre", PopupIds.CREATE_SUB_SUBTITLE)
	_pm.connect("id_pressed", self, "_on_PopupMenu_id_pressed")
	get_node("Titlemenuaddition/Inputtitle").clear()
	
	var _text_popup = get_node("CanvasLayer/Panel2/VBoxContainer/Create texte")
	
	_pm.popup(Rect2(_text_popup.get_global_rect().position.x - 154, _text_popup.get_global_rect().position.y, _pm.rect_size.x, _pm.rect_size.y))


func _on_Draw_pressed():
	_pm.clear()
	_pm.add_item("Ecriture -> Dessin", PopupIds.WRITING_DRAWING)
	_pm.add_item("Dessin", PopupIds.WRITING)
	_pm.connect("id_pressed", self, "_on_PopupMenu_id_pressed")
	
	var _draw_popup = get_node("CanvasLayer/Panel2/VBoxContainer/Draw")
	_pm.popup(Rect2(_draw_popup.get_global_rect().position.x - _pm.get_global_rect().size.x, _draw_popup.get_global_rect().position.y, _pm.rect_size.x, _pm.rect_size.y))


func _on_PopupMenu_id_pressed(id):
	if id==1:
		
		get_node("Titlemenuaddition").type_title = 1
		
		#changes the appearance of the title menu addition following what's being created
		get_node("Titlemenuaddition/Titlemenu").visible  = true
		get_node("Titlemenuaddition/Subtitlemenu").visible  = false
		get_node("Titlemenuaddition/Subsubtitlemenu").visible  = false
		
		get_node("Titlemenuaddition/Inputtitle").placeholder_text = "Titre"
		
		#Puts the title menu addition where it was clicked on the screen 
		var _mouse_pos = get_global_mouse_position()
		var size_title_menu_x = get_node("Titlemenuaddition/ColorRect").get_global_rect().size.x
		var size_title_menu_y = get_node("Titlemenuaddition/ColorRect").get_global_rect().size.y
		get_node("Titlemenuaddition").position.x = _camera.get_camera_position().x - (size_title_menu_x/5)
		get_node("Titlemenuaddition").position.y = _camera.get_camera_position().y - (size_title_menu_y/5)
		get_node("Titlemenuaddition").visible = true
		#makes the right-click menu disappear faster
		get_node("RightClickContainer").visible = false
		
		
	elif id==2:
		
		get_node("Titlemenuaddition").type_title = 2
		#changes the appearance of the title menu addition following what's being created
		get_node("Titlemenuaddition/Subtitlemenu").visible  = true
		get_node("Titlemenuaddition/Subsubtitlemenu").visible  = false
		get_node("Titlemenuaddition/Titlemenu").visible  = false
		get_node("Titlemenuaddition/Inputtitle").placeholder_text = "Sous-titre"
		
		
		#Puts the title menu addition where it was clicked on the screen 
		var size_title_menu_x = get_node("Titlemenuaddition/ColorRect").get_global_rect().size.x
		var size_title_menu_y = get_node("Titlemenuaddition/ColorRect").get_global_rect().size.y
		get_node("Titlemenuaddition").position.x = _camera.get_camera_position().x - (size_title_menu_x/5)
		get_node("Titlemenuaddition").position.y = _camera.get_camera_position().y - (size_title_menu_y/5)
		
		get_node("Titlemenuaddition").visible = true
		#makes the right-click menu disappear faster
		get_node("RightClickContainer").visible = false
		
	elif id==3:
		
		get_node("Titlemenuaddition").type_title = 3
		
		#changes the appearance of the title menu addition following what's being created
		get_node("Titlemenuaddition/Subsubtitlemenu").visible  = true
		get_node("Titlemenuaddition/Titlemenu").visible  = false
		get_node("Titlemenuaddition/Subtitlemenu").visible  = false
		get_node("Titlemenuaddition/Inputtitle").placeholder_text = "Sous sous-titre"
		
		
		#Puts the title menu addition where it was clicked on the screen 
		var size_title_menu_x = get_node("Titlemenuaddition/ColorRect").get_global_rect().size.x
		var size_title_menu_y = get_node("Titlemenuaddition/ColorRect").get_global_rect().size.y
		get_node("Titlemenuaddition").position.x = _camera.get_camera_position().x - (size_title_menu_x/5)
		get_node("Titlemenuaddition").position.y = _camera.get_camera_position().y - (size_title_menu_y/5)
		get_node("Titlemenuaddition").visible = true
		#makes the right-click menu disappear faster
		get_node("RightClickContainer").visible = false
		
	elif id==4:
		print("Ecriture vers Dessin")
	elif id==5:
		print("Dessin")

	
	get_node("Titlemenuaddition/Inputtitle").grab_focus()
