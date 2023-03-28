class_name Canvas
extends Node2D

# Import static methodes packages
# (General scripts)
var Utils := preload("res://Scripts/Utilities/Utilities.gd").new()
var Mimic := preload("res://Scripts/Utilities/BuiltInMimic.gd").new()
# (State relative scripts)
var DragAndDrop := preload("res://Scripts/Modes/DragAndDrop.gd").new()
var Rescale := preload("res://Scripts/Modes/Rescale.gd").new()
var Rotation := preload("res://Scripts/Modes/Rotation.gd").new()

# Import dynamic instances packages
var RTL := preload("res://Scripts/Title.gd")
var AREASELECTION := preload("res://Scripts/AreaSelection.gd")

# Get references to childs 
onready var _background := $BackgroundColored
onready var _camera := $Camera
onready var _elements := $Elements
onready var detached_RCC := $RightClickContainer
onready var RCC := $CanvasLayer/Panel2/VBoxContainer
onready var _action_menu := $ActionMenu
onready var _pm = $PopupMenu
onready var states = $StateManager

# Script exported variables
export (float) var linewidth = 4.0

# Veriables shared between states
var Select_rect: Area2D
var Selection_area : Area2D
var selected_lines: Array
var snapshots: Dictionary = {
	"snapshots" : [],
	"current_index" : 0
}

###################################################################################################
#global variables added for default options (making testing from the Main.tscn possible without crash)
#they should be deleted when the program is finished
var title_font
var subtitle_font 
var subsubtitle_font
var color_title 
var color_subtitle  
var color_subsubtitle 

onready var _linecounter := get_node("CanvasLayer/HBoxContainer/LinesCounter")
####################################################################################################


func _ready() -> void:
	# Initialisation
	# Gives states control to the state manager
	states.init(self)
	# Create the first snapshot to recover previous step
	snapshots = create_snapshot(snapshots)
	
	# Connect signals
	
	
	#connects the signal on new title input 
	#and calls the function taking care of effectively creating it 
	
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

func _input(event: InputEvent):
	states.keyboard_input(event)
 
func _on_BackgroundColored_gui_input(event: InputEvent):
	states.input(event)

func _physics_process(delta):
	states.physics_process(delta)
	

#Creates the new richtextlabel node with the new wanted title
func create_new_title(chosen_title):
	get_node("Titlemenuaddition").visible = false
	
	#position of the title is the same as the title menu addition 
	#which was set from the retrieved position of the right-click
	
	var rtl = RTL.new()
	var x_pos_title = get_node("Titlemenuaddition").position.x 
	var y_pos_title = get_node("Titlemenuaddition").position.y 
	var rtl_position = Vector2(x_pos_title, y_pos_title)
	get_node("Elements").add_child(rtl)
	rtl.set_params(true, str(chosen_title), Vector2(500, 100), rtl_position)

	
	var type_title = get_node("Titlemenuaddition").type_title
	rtl.ChangeFont(type_title, title_font, color_title, subtitle_font, color_subtitle, subsubtitle_font, color_subsubtitle)


"""
Draw a line to make a container around the selected lines
Parameters :
---------------
drawing : bool -> launch draw function if true
"""
func DrawLineContainer(drawing:bool):
	for element in selected_lines:
#		if element[0] is AreaSelection:
#			print("UPDATE")
#			element[0].draw = drawing
#			element[0].update()
		if element[0] is Stroke  or element[0] is Title:
			# lancer la fonction _draw setup dans Line.gd
			element[0].draw = drawing
			# lance la fonction draw() de godot (update() lance draw())
			element[0].update()
			


"""
Create and append the selection area to selected_lines 
"""
func appendSelectionArea() -> void :
	var corners = get_selection_area_corner()
	var upper_left = corners[0]
	var bottom_right = corners[1]
	var area_size = get_position_area_size()
	var min_x = area_size[0]
	var min_y = area_size[1]
	var sLines = Utils.map(selected_lines, Mimic, "get_first", [])
	var sPosition = Utils.map(sLines, Mimic, "area2D_position", [])
	var closure = Utils.get_positions_closure(sPosition)
	var center = Utils.get_positions_mean(closure)
		
	var area_size_vec = Vector2(bottom_right[0] * 2, bottom_right[1] * 2)
	var size_x = bottom_right[0] * 2
	var size_y = bottom_right[1] * 2
		
	Selection_area.set_params(min_x, min_y, size_x, size_y, upper_left, bottom_right)
	Selection_area.set_param(center/2)
	Selection_area.create_selection_area(selected_lines)
	print(Selection_area.position)



"""
Calls DrawLineContainer whith the drawing bool to true
"""
func RetrieveArea(areas:Array):
	selected_lines = areas.duplicate()
	
	Selection_area = AREASELECTION.new()
	get_node("Elements").add_child(Selection_area)
	appendSelectionArea()
	
	selected_lines.append([Selection_area, 0])
	
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


func create_snapshot(snapshots: Dictionary) -> Dictionary:
	var elements: Node2D = get_match_string_node("Elements", self).duplicate()
	
	if snapshots["current_index"] != snapshots["snapshots"].size()-1 and snapshots["snapshots"] != [] :
		snapshots["snapshots"].resize(snapshots["current_index"]+1)
	print(snapshots)
	if snapshots["snapshots"].size() <= 10:
		snapshots["snapshots"].append(elements)
	
	else:
		var out_of_scope: Node2D = snapshots["snapshots"][0]
		snapshots["snapshots"].remove(0)
		out_of_scope.queue_free()
		snapshots["snapshots"].append(elements)

	snapshots["current_index"] = snapshots["snapshots"].size()-1
	
	return snapshots

func reload_snapshot(index: int, snapshots: Dictionary) -> Dictionary:
	print(index, snapshots)
	if index >= 0 && index < snapshots["snapshots"].size():
		var elements: Node2D = get_match_string_node("Elements", self)
		print(elements)
		elements.queue_free()
		
		var new_elements: Node2D = snapshots["snapshots"][index].duplicate(true)
		self.add_child(new_elements)
		_elements = new_elements
		#self.selected_lines = selected_lines
		
		snapshots["current_index"] = index
	
	return snapshots
	
func get_match_string_node(expr: String, father: Object) -> Object:
	var children: Array = father.get_children()
	for child in children:
		if child.name.match("*"+expr+"*"):
			return child
			
	return null
