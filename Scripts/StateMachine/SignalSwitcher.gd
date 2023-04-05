extends IState

# Selection nodes to set with the Godot engine.
export (NodePath) var zoom_camera_node
export (NodePath) var move_canvas_node
export (NodePath) var drawing_node
export (NodePath) var selection_node
export (NodePath) var copy_node
export (NodePath) var paste_node
export (NodePath) var delete_node
export (NodePath) var drag_and_drop_node
export (NodePath) var rescale_node
export (NodePath) var rotation_node
export (NodePath) var undo_node
export (NodePath) var redo_node
export (NodePath) var group_node
export (NodePath) var ungroup_node
export (NodePath) var fusion_node
export (NodePath) var create_title_node

onready var zoom_camera: IState = get_node(zoom_camera_node)
onready var move_canvas: IState = get_node(move_canvas_node)
onready var drawing: IState = get_node(drawing_node)
onready var selection: IState = get_node(selection_node)
onready var copy: IState = get_node(copy_node)
onready var paste: IState = get_node(paste_node)
onready var delete: IState = get_node(delete_node)
onready var drag_and_drop: IState = get_node(drag_and_drop_node)
onready var rescale: IState = get_node(rescale_node)
onready var rotation: IState = get_node(rotation_node)
onready var undo: IState = get_node(undo_node)
onready var redo: IState = get_node(redo_node)
onready var group: IState = get_node(group_node)
onready var ungroup: IState = get_node(ungroup_node) 
onready var fusion: IState = get_node(fusion_node)
onready var create_title: IState = get_node(create_title_node)

"""
Function called to switch the state according to the keyboard input.

Parameters:
-----------
event: The input event to consume. (InputEvent)

Returns:
--------
The state to switch to. (IState)
"""
func keyboard_input(event: InputEvent) -> IState:
	if Input.is_action_just_pressed("Zoom") || Input.is_action_just_pressed("Unzoom"):
		if get_node("../../StateManager").current_state == rescale:
			return rescale
		else:
			return zoom_camera
	
	if Input.is_action_just_pressed("MoveCanvas"):
		return move_canvas
	
	if Input.is_action_just_pressed("Drawing"):
		return drawing
	
	if Input.is_action_just_pressed("Selection"):
		return selection
	
	if Input.is_action_just_pressed("Copy"):
		return copy
	
	if Input.is_action_just_pressed("Paste"):
		return paste
	
	if Input.is_action_just_pressed("Delete"):
		return delete
	
	if Input.is_action_just_pressed("DragAndDrop"):
		return drag_and_drop
	
	if Input.is_action_just_pressed("Undo"):
		return undo
	elif event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_Z and not event.control:
			return rescale
		
	if Input.is_action_just_pressed("Redo"):
		return redo
	
	return null

"""
Function called to switch to the previous state.
"""
func switch_to_previous_state() -> IState:
	return get_node("../../StateManager").previous_state

"""
Function called to switch the state according to a signal.

Parameters:
-----------
state: The next state to switch to. (String)

Returns:
--------
The state to transit to. (IState)
"""
func switch_signal(state: String) -> IState:
	match state:
		"MoveCanvas":
			return move_canvas
		"Drawing":
			return drawing
		"Selection":
			return selection
		"Copy":
			return copy
		"Paste":
			return paste
		"Delete":
			return delete
		"DragAndDrop":
			return drag_and_drop
		"Rescale":
			return rescale
		"Rotation":
			return rotation
		"Undo":
			return undo
		"Redo":
			return redo
		"Group":
			return group
		"Ungroup":
			return ungroup
		"Fusion":
			return fusion
		"CreateTitle":
			return create_title
		_:
			return null

