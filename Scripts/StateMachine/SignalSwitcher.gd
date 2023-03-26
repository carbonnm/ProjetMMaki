extends IState

# Selection nodes to set with the Godot engine.
export (NodePath) var zoom_node
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

onready var zoom: IState = get_node(zoom_node)
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


func keyboard_input(event: InputEvent) -> IState:
	# Pass the control to the camera
	var zoomC1 = event is InputEventMouseButton && event.button_index == BUTTON_WHEEL_UP
	var zoomC2 = event is InputEventMouseButton && event.button_index == BUTTON_WHEEL_DOWN
	var zoomC3 = event is InputEventMouseMotion && event.button_mask == BUTTON_MASK_LEFT && event.alt
	var zoomC4 = event is InputEventMouseMotion && event.button_mask == BUTTON_MASK_MIDDLE
	if zoomC1 || zoomC2 || zoomC3 || zoomC4:
		return zoom
	
	# Pass the control to the Undo
	if Input.is_action_just_pressed("Undo"):
		return undo
	
	# Pass the control to the Redo
	if Input.is_action_just_pressed("Redo"):
		return redo
	
	return null

func switch_to_previous_state() -> IState:
	return get_node("../../StateManager").previous_state

func switch_signal(state: String) -> IState:
	print("state",state)
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
			print(group)
			return group
		_:
			return null

