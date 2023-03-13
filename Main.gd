extends Node2D

#signal Line_count(counter)

var LINE := preload("res://Scripts/Line.gd")
var RTL := preload("res://Scripts/Title.gd")

var DragAndDrop := preload("res://Scripts/Modes/DragAndDrop.gd").new()
var Rescale := preload("res://Scripts/Modes/Rescale.gd").new()
var Rotation := preload("res://Scripts/Modes/Rotation.gd").new()


var Utils := preload("res://Scripts/Utilities/Utilities.gd").new()
var Mimic := preload("res://Scripts/Utilities/BuiltInMimic.gd").new()

onready var _background := $BackgroundColored
onready var _camera := $Camera
onready var _lines := $Lines
onready var _linecounter := get_node("CanvasLayer/HBoxContainer/LinesCounter")
onready var _action_menu := $ActionMenu

onready var RCC := $RightClickContainer

onready var _pm = $PopupMenu

var linewidth: float = 4.0

var _current_line : Area2D
var selected_lines : Array
var Select_rect : Area2D
var copy_lignes : Array

#list used for undo (ctr+Z), redo (ctrl+Y)
var created_elements : Array 
var index_created 
var notyetundo = true

#global variables added for default options (making testing from the Main.tscn possible without crash)
#they should be deleted when the program is finished
var title_font
var subtitle_font 
var subsubtitle_font
var color_title 
var color_subtitle  
var color_subsubtitle 


var Modes = {
	"Drawing": true,
	"Select": false,
	"DragAndDrop": false,
	"Rescale": false,
	"Rotate": false
}

func _ready() -> void:
	index_created = created_elements.size()
	_camera.connect("zoom_changed", self, "UpdateBackground")
	
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
					_current_line.Curve2D_Transformer(_camera)
			if Modes.Select:
				#recurring bug 
				#(Attempt to call function 'queue_free' in base 'previously freed instance' on a null instance.)
				if Select_rect:
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
				var area2D_L = Utils.map(selected_lines,Mimic,"get_first",[])
				var mouse_relative = event.relative
				DragAndDrop.drag_and_drop(area2D_L,mouse_relative)
			elif Modes.Rescale:
				var area2D_L = Utils.map(selected_lines,Mimic,"get_first",[])
				var mouse_position = get_global_mouse_position()
				var mouse_relative = event.relative
				Rescale.rescale(area2D_L,mouse_position,mouse_relative)
			elif Modes.Rotate:
				var area2D_L = Utils.map(selected_lines,Mimic,"get_first",[])
				var mouse_position = get_global_mouse_position()
				var mouse_relative = event.relative
				Rotation.rotation(area2D_L,mouse_position,mouse_relative)
				
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
	for element in selected_lines:
		if element[0] is Stroke :
			# lancer la fonction _draw setup dans Line.gd
			element[0].draw = drawing
			# lance la fonction draw() de godot (update() lance draw())
			element[0].update()

# delete les lignes selectionnées
func _on_Delete_pressed():
	for area in selected_lines:
		area[0].queue_free()
		
	selected_lines.clear()
	_action_menu.hide()
	#emit_signal("Line_count",0)
	#Updates elements counter 
	_linecounter.Count = str(_lines.get_child_count())
	print(_linecounter.Count)

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
	
	print(created_elements,_lines.get_child_count())
	_linecounter.Count = str(_lines.get_child_count())
	#emit_signal("Line_count",_lines.get_child_count())

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

"""
Change mode to Rescale when rescale button pressed.
"""
func _on_Rescale_pressed():
	Change_mode("Rescale")
	_action_menu.hide()

"""
Change mode to Rotate when rotation button pressed
"""
func _on_Rotation_pressed():
	Change_mode("Rotate")
	_action_menu.hide()

"""
When copy button pressed, create a duplication of the selected area
(Not even necessary ? To discuss later)
"""
func _on_Copy_pressed():
	_action_menu.hide()
	copy_lignes = selected_lines.duplicate()
		

"""
When paste button pressed, create a duplication of the selected area
Then Paste it where the mouse actually is (to be changed with the right click)
"""
func _on_Paste_pressed():
	_action_menu.hide()
	var clines = Utils.map(copy_lignes,Mimic,"get_first",[])
	var clines_positions = Utils.map(clines, Mimic, "area2D_position", [])
	var closure = Utils.get_positions_closure(clines_positions)
	var center = Utils.get_positions_mean(closure)
	var translation = -center + RCC.rect_position
	
	for Ligne in clines:
		var duplarea = Ligne.duplicate()
		
		duplarea.position += translation
		_lines.add_child(duplarea)
		
		if duplarea is Stroke:
			duplarea._line = duplarea.get_child(0)

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
	
	var _mouse_pos = get_global_mouse_position()
	_pm.popup(Rect2(_mouse_pos.x, _mouse_pos.y, _pm.rect_size.x, _pm.rect_size.y))
	


func _on_Draw_pressed():
	_pm.clear()
	_pm.add_item("Ecriture -> Dessin", PopupIds.WRITING_DRAWING)
	_pm.add_item("Dessin", PopupIds.WRITING)
	_pm.connect("id_pressed", self, "_on_PopupMenu_id_pressed")
	
	var _mouse_pos = get_global_mouse_position()
	_pm.popup(Rect2(_mouse_pos.x, _mouse_pos.y, _pm.rect_size.x, _pm.rect_size.y))


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
		get_node("Titlemenuaddition").position.x = (get_viewport_rect().size.x / 2) - (size_title_menu_x/5)
		get_node("Titlemenuaddition").position.y = (get_viewport_rect().size.y / 2) - (size_title_menu_y/5)
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
		get_node("Titlemenuaddition").position.x = (get_viewport_rect().size.x / 2) - (size_title_menu_x/5)
		get_node("Titlemenuaddition").position.y = (get_viewport_rect().size.y / 2) - (size_title_menu_y/5)
		
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
		get_node("Titlemenuaddition").position.x = (get_viewport_rect().size.x / 2) - (size_title_menu_x/5)
		get_node("Titlemenuaddition").position.y = (get_viewport_rect().size.y / 2) - (size_title_menu_y/5)
		get_node("Titlemenuaddition").visible = true
		#makes the right-click menu disappear faster
		get_node("RightClickContainer").visible = false
		
	elif id==4:
		print("Ecriture vers Dessin")
	elif id==5:
		print("Dessin")

	
	get_node("Titlemenuaddition/Inputtitle").grab_focus()


#handles the undo 
func _on_RightClickContainer_undo():
	print("startundo",index_created)
	#handles the first undo (to initialize index_created following the nulber of created elements
	if notyetundo and created_elements.size()>0:
		notyetundo = false
		index_created = created_elements.size()-1
	
	if(index_created>=0):		
		var to_delete = created_elements[index_created]
		
		#opened to better solution 
		to_delete.visible = false
		index_created -=1	
		#created_elements.remove(size_list-1)
		
	print("done",index_created)
	

func _on_RightClickContainer_redo():
	
	if not notyetundo and index_created<created_elements.size()-1:
		print("startredo",index_created)
		var to_recreate = created_elements[index_created]
		print(to_recreate.name)
		to_recreate.visible = true
		index_created += 1
	print("done",index_created)
