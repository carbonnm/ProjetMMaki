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

var SVGCompiler := preload("res://SavePlugin/SVGCompiler.gd")

# Get references to childs 
onready var _background := $BackgroundColored
onready var _camera := $Camera
onready var _elements := $Elements
onready var detached_RCC := $RightClickContainer
onready var RCC := $CanvasLayer/Panel2/VBoxContainer
onready var _action_menu := $ActionMenu
onready var pm = $PopupMenu
onready var states = $StateManager

# Script exported variables
export (float) var linewidth = 4.0
export (Vector2) var drawing_position
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
	if event is InputEventKey and event.scancode == KEY_O:
		var i = 1
		if i == 1:
			var save_node = Utils.get_match_string_node("Elements", self)
			var background_node = Utils.get_match_string_node("BackgroundColor", self)
			var svg_compiler = SVGCompiler.new([save_node, background_node])
			svg_compiler.export_to_svg()
			i += 1
 
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
	Selection_area.create_selection_area(selected_lines)



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
		var mouse_position : Vector2 = get_global_mouse_position()
		var background_x : int = _background.rect_size.x
		var backrgound_y : int = _background.rect_size.y 
		
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
	var min_upper_left : Vector2 = Vector2.INF
	var max_bottom_right : Vector2
	var min_x : float = 1024.0
	var min_y : float = 600.0
	var max_x : float
	var max_y : float
	var points_positions : Array = []
	
	for element in selected_lines : 
		if element[0] is Stroke :
			for point in element[0]._line.points:
				points_positions.append(point)
			
			var corners : Array = Utils.get_positions_corners(points_positions)
			var upper_left : Vector2 = corners[0] + element[0].position
			var bottom_right : Vector2 = corners[1] + element[0].position
			if upper_left.x < min_x :
				min_x = upper_left.x
			if upper_left.y < min_y :
				min_y = upper_left.y
			if bottom_right.x > max_x :
				max_x = bottom_right.x
			if bottom_right.y > max_y :
				max_y = bottom_right.y
		
		if element[0] is Title :
			#Get Title position : 
			var position_title : Vector2 = element[0].position + Utils.get_child_of_type(element[0], "TextEdit").rect_position
			#Check if upper_left corner of the title is smaller than the min
			if position_title.x < min_x :
				min_x = position_title.x
			if position_title.y < min_y :
				min_y = position_title.y
			#Check if the bottom_right corner of the title is greater than the max
			var bottom_right : Vector2 = position_title + Utils.get_child_of_type(element[0], "TextEdit").rect_size
			if bottom_right.x > max_x :
				max_x = bottom_right.x
			if bottom_right.y > max_y :
				max_y = bottom_right.y
	
	min_upper_left = Vector2(min_x, min_y)
	max_bottom_right = Vector2(max_x, max_y)
	
	return [min_upper_left,max_bottom_right]


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
	pm.clear()
	pm.add_item("Créer titre", PopupIds.CREATE_TITLE)
	pm.add_item("Créer sous-titre", PopupIds.CREATE_SUBTITLE)
	pm.add_item("Créer sous sous-titre", PopupIds.CREATE_SUB_SUBTITLE)
	pm.connect("id_pressed", self, "_on_PopupMenu_id_pressed")
	get_node("Titlemenuaddition/Inputtitle").clear()
	var _text_popup = get_node("CanvasLayer/Panel2/VBoxContainer/Create texte")
	pm.popup(Rect2(_text_popup.get_global_rect().position.x - 154, _text_popup.get_global_rect().position.y, pm.rect_size.x, pm.rect_size.y))

func _on_Create_texte_RCC_pressed():
	pm.clear()
	pm.add_item("Créer titre", PopupIds.CREATE_TITLE)
	pm.add_item("Créer sous-titre", PopupIds.CREATE_SUBTITLE)
	pm.add_item("Créer sous sous-titre", PopupIds.CREATE_SUB_SUBTITLE)
	pm.connect("id_pressed", self, "_on_PopupMenu_id_RCC_pressed")
	get_node("Titlemenuaddition/Inputtitle").clear()
	var _text_popup = get_node("RightClickContainer/Create texte")
	pm.popup(Rect2(_text_popup.get_global_rect().position.x - 154, _text_popup.get_global_rect().position.y, pm.rect_size.x, pm.rect_size.y))


func _on_Draw_pressed():
	pm.clear()
	pm.add_item("Ecriture -> Dessin", PopupIds.WRITING_DRAWING)
	pm.add_item("Dessin", PopupIds.WRITING)
	pm.connect("id_pressed", self, "_on_PopupMenu_id_pressed")
	var _draw_popup = get_node("ActionMenu")
	pm.popup(Rect2(_draw_popup.get_global_rect().position.x - 135, _draw_popup.get_global_rect().position.y + 200, pm.rect_size.x, pm.rect_size.y))


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
		get_node("Titlemenuaddition").rect_position.x = _camera.get_camera_position().x - (size_title_menu_x/5)
		get_node("Titlemenuaddition").rect_position.y = _camera.get_camera_position().y - (size_title_menu_y/5)
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
		get_node("Titlemenuaddition").rect_position.x = _camera.get_camera_position().x - (size_title_menu_x/5)
		get_node("Titlemenuaddition").rect_position.y = _camera.get_camera_position().y - (size_title_menu_y/5)
		
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
		get_node("Titlemenuaddition").rect_position.x = _camera.get_camera_position().x - (size_title_menu_x/5)
		get_node("Titlemenuaddition").rect_position.y = _camera.get_camera_position().y - (size_title_menu_y/5)
		get_node("Titlemenuaddition").visible = true
		#makes the right-click menu disappear faster
		get_node("RightClickContainer").visible = false
		
	elif id==4:
		get_node("ActionMenu").visible = false
		
		yield(get_tree().create_timer(1.0), "timeout")
		
		var path = "ScreenShots/screenshot.png"
		
		var corners : Array = get_selection_area_corner()
		var upper_left : Vector2 = corners[0]
		drawing_position = upper_left
		var bottom_right : Vector2 = corners[1]
		var size_area : Vector2 = bottom_right - upper_left
		var center_selected_lines = (bottom_right + upper_left)/2
		
		var margin : Vector2 = Vector2(50, 50)
		var capture_rect = Rect2(upper_left - margin, size_area + 2 * margin)
		
		var viewport = get_viewport() 
		var screenshot = viewport.get_texture().get_data()
		screenshot.flip_y()
		screenshot.get_rect(capture_rect).save_png(path)
		
		var word = word_recognition_python()
		
		var size_popup : Vector2 = get_node("PopUpMotConfirmation/ColorRect").get_global_rect().size
		
		get_node("PopUpMotConfirmation").rect_position = _camera.get_camera_position() - (size_popup/5)
		get_node("PopUpMotConfirmation/Mot").text = word[0]
		get_node("PopUpMotConfirmation").visible = true
		
		delete_word()
		
		
	elif id==5:
		print("Dessin")
	
	get_node("Titlemenuaddition/Inputtitle").grab_focus()

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
	OS.execute("python", ["Scripts/WordRecognition.py"], true, output)
	print(output)
	return output



func _on_PopupMenu_id_RCC_pressed(id):
	var _mouse_pos : Vector2 = get_global_mouse_position()
	var size_title_menu_x : float = get_node("Titlemenuaddition/ColorRect").get_global_rect().size.x
	var size_title_menu_y : float = get_node("Titlemenuaddition/ColorRect").get_global_rect().size.y
	if id==1:
		
		get_node("Titlemenuaddition").type_title = 1
		#changes the appearance of the title menu addition following what's being created
		get_node("Titlemenuaddition/Titlemenu").visible  = true
		get_node("Titlemenuaddition/Subtitlemenu").visible  = false
		get_node("Titlemenuaddition/Subsubtitlemenu").visible  = false
		
		get_node("Titlemenuaddition/Inputtitle").placeholder_text = "Titre"
		
		
		if _mouse_pos.x > 600 and _mouse_pos.y > 400:
			get_node("Titlemenuaddition").rect_position.x = 600
			get_node("Titlemenuaddition").rect_position.y = 400
		
		elif _mouse_pos.y > 400:
			get_node("Titlemenuaddition").rect_position.x = _mouse_pos.x
			get_node("Titlemenuaddition").rect_position.y = 400
		
		elif _mouse_pos.x > 600 :
			get_node("Titlemenuaddition").rect_position.x = 600
			get_node("Titlemenuaddition").rect_position.y = _mouse_pos.y
		
		else : 
			get_node("Titlemenuaddition").rect_position = _mouse_pos
			
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
		
		if _mouse_pos.x > 600 and _mouse_pos.y > 400:
			get_node("Titlemenuaddition").rect_position.x = 600
			get_node("Titlemenuaddition").rect_position.y = 400
		
		elif _mouse_pos.y > 400:
			get_node("Titlemenuaddition").rect_position.x = _mouse_pos.x
			get_node("Titlemenuaddition").rect_position.y = 400
		
		elif _mouse_pos.x > 600 :
			get_node("Titlemenuaddition").rect_position.x = 600
			get_node("Titlemenuaddition").rect_position.y = _mouse_pos.y
		
		else : 
			get_node("Titlemenuaddition").rect_position = _mouse_pos
		
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
		
		if _mouse_pos.x > 600 and _mouse_pos.y > 400:
			get_node("Titlemenuaddition").rect_position.x = 600
			get_node("Titlemenuaddition").rect_position.y = 400
		
		elif _mouse_pos.y > 400:
			get_node("Titlemenuaddition").rect_position.x = _mouse_pos.x
			get_node("Titlemenuaddition").rect_position.y = 400
		
		elif _mouse_pos.x > 600 :
			get_node("Titlemenuaddition").rect_position.x = 600
			get_node("Titlemenuaddition").rect_position.y = _mouse_pos.y
		
		else : 
			get_node("Titlemenuaddition").rect_position = _mouse_pos

		get_node("Titlemenuaddition").visible = true
		#makes the right-click menu disappear faster
		get_node("RightClickContainer").visible = false
	
	get_node("Titlemenuaddition/Inputtitle").grab_focus()



func _on_Save_canvas_pressed() -> void:
	var packed_scene = PackedScene.new()
	
	for child in Utils.get_all_children(_elements):
		child.set_owner(_elements)
	
	packed_scene.pack(_elements)
	ResourceSaver.save("user://my_scene.tscn", packed_scene)

func LoadSave() -> void:
	var _scene = ResourceLoader.load("user://my_scene.tscn").instance()
	_elements.queue_free()
	add_child(_scene)
	move_child(_scene, 2)
	_elements = _scene









