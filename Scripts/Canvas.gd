class_name Canvas
extends Node2D

# Import static methodes packages
# (General scripts)
var Utils := preload("res://Scripts/Utilities/Utilities.gd").new()
var Mimic := preload("res://Scripts/Utilities/BuiltInMimic.gd").new()
# (User Customization scripts)
var Custom := preload("res://Scripts/Customization.gd")
var AREASELECTION := load("res://Scripts/AreaSelection.gd")
# (State relative scripts)
var DragAndDrop := preload("res://Scripts/Modes/DragAndDrop.gd").new()
var Rescale := preload("res://Scripts/Modes/Rescale.gd").new()
var Rotation := preload("res://Scripts/Modes/Rotation.gd").new()
var CreateTitle := preload("res://Scripts/StateMachine/StatesMethods/TitleMethods.gd").new()
var Snapshots := preload("res://Scripts/StateMachine/StatesMethods/Snapshots.gd")

# Get references to childs 
onready var _background := $BackgroundColored
onready var _camera := $Camera
onready var _elements := $Elements
onready var detached_RCC := $CanvasLayer/RightClickContainer
onready var RCC := $CanvasLayer/Panel2/VBoxContainer
onready var _action_menu := $CanvasLayer/ActionMenu
onready var pm = $PopupMenu
onready var states = $StateManager
onready var PanelVisibility := get_node("CanvasLayer")

# Script exported variables
export (float) var linewidth = 4.0
export (Vector2) var drawing_position
export (String) var word_recognized

#export (Array) var selected_lines

# Veriables shared between states
var Select_rect: Area2D
var Selection_area : Area2D
var selected_lines: Array
var snapshots: Node
var custom: Node

func _ready() -> void:
	# Initialisation
	# Gives states control to the state manager
	states.init(self)
	# Create the first snapshot to recover previous step
	snapshots = Snapshots.new(self, Utils.get_match_string_node("Elements", self))
	snapshots.create_snapshot()
	# Setup canvas (Name; (sub-(sub-))Title Color/Font; Background Color
	custom = Custom.new(SceneSwitcher)
	get_node("BackgroundColored").color = custom.customization["backgroundcolor"]

func _input(event: InputEvent):
	states.keyboard_input(event)
 
func _on_BackgroundColored_gui_input(event: InputEvent):
	states.input(event)

func _physics_process(delta):
	states.physics_process(delta)










"""
Draw a line to make a container around the selected lines
Parameters :
---------------
drawing : bool -> launch draw function if true
"""
func DrawLineContainer(drawing:bool):
	for element in selected_lines:
		if element[0] is AreaSelection:
			element[0].draw = drawing
			element[0].update()
#		if element[0] is Stroke  or element[0] is Title:
#			# lancer la fonction _draw setup dans Line.gd
#			element[0].draw = drawing
#			# lance la fonction draw() de godot (update() lance draw())
#			element[0].update()
			


"""
Create and append the selection area to selected_lines 
"""
func appendSelectionArea() -> void :
	var corners = get_selection_area_corner()
	var upper_left = corners[0]
	var bottom_right = corners[1]
		
	Selection_area.set_params(upper_left, bottom_right)
	Selection_area.create_selection_area()



"""
Calls DrawLineContainer whith the drawing bool to true
"""
func RetrieveArea(areas:Array):
	selected_lines = areas.duplicate()

	Selection_area = AREASELECTION.new()
	Utils.get_match_string_node("Elements",self).add_child(Selection_area)
	appendSelectionArea()

	selected_lines.append([Selection_area, 0])
	
	DrawLineContainer(true)
	if selected_lines.size() != 0:
		var mouse_position : Vector2 = $CanvasLayer/ActionMenu.get_global_mouse_position()
		var background_x : int = 1024
		var backrgound_y : int = 600
		
		if mouse_position.x > background_x - _action_menu.rect_size.x and mouse_position.y > backrgound_y - _action_menu.rect_size.y :
			_action_menu.rect_position.x = mouse_position.x - _action_menu.rect_size.x
			_action_menu.rect_position.y = backrgound_y - _action_menu.rect_size.y
		elif mouse_position.y > backrgound_y - _action_menu.rect_size.y :
			_action_menu.rect_position.x = mouse_position.x
			_action_menu.rect_position.y = backrgound_y - _action_menu.rect_size.y
		elif mouse_position.x > background_x - _action_menu.rect_size.x :
			_action_menu.rect_position.x = background_x - _action_menu.rect_size.x
			_action_menu.rect_position.y = mouse_position.y
		else : 
			_action_menu.rect_position = mouse_position
		_action_menu.show()
		
"""
Gets the corner of the selection_area
Returns : Array  
"""
func get_selection_area_corner() :
	var elements: Array = Utils.map(selected_lines, Mimic, "get_first", [])
	
	var positions := PoolVector2Array()
	for element in elements:
		var children: Array = element.get_children()
		for child in children:
			var child_positions := PoolVector2Array()
			if child is CollisionShape2D:
				if child.shape is RectangleShape2D:
					child_positions.append(child.position - child.shape.extents)
					child_positions.append(child.position + child.shape.extents)
					child_positions.append(child.position + Vector2(child.shape.extents.x, -child.shape.extents.y))
					child_positions.append(child.position + Vector2(-child.shape.extents.x, child.shape.extents.y))
				elif child.shape is ConvexPolygonShape2D:
					child_positions = child.shape.points
				
				child_positions = child.global_transform.xform(child_positions)
				
				positions += child_positions
	
	return Utils.get_positions_corners(positions)

"""
Draw the geometrical selection area around the selected lines 
Calls DrawLineContainer()
Is called when select button is pressed
"""
func DrawSelectionArea():
	Select_rect = Area2D.new()
	Select_rect.set_script(load("res://Scripts/Selector.gd"))
	var _error = Select_rect.connect("SendArea", self, "RetrieveArea")
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


func _on_Create_text_pressed():
	var _text_popup = get_node("CanvasLayer/Panel2/VBoxContainer/Create texte")
	get_node("TitleCreationPopUp").rect_global_position = Vector2(_text_popup.get_global_rect().position.x - 154, _text_popup.get_global_rect().position.y)
	get_node("TitleCreationPopUp").visible = true

func _on_Create_texte_RCC_pressed():
	var _text_popup = get_node("CanvasLayer/RightClickContainer/Create texte")
	get_node("TitleCreationPopUp").rect_global_position = Vector2(_text_popup.get_global_rect().position.x - 153, _text_popup.get_global_rect().position.y)
	get_node("TitleCreationPopUp").visible = true
	

"""
Clear the handwritten word
"""
func delete_word() :
	for element in selected_lines :
		element[0].queue_free()
	selected_lines.clear()


"""
Executes the Python Script that recognize the word written
Return : 
-----------------
- the word written
"""
func word_recognition_python() :
	var output : Array = []
	var _error = OS.execute("python", ["Scripts/WordRecognition.py"], true, output)
	return output
