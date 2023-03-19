extends IState

# Selection nodes to set with the Godot engine.
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


func switch_signal(state: String) -> IState:
	match state:
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
		_:
			return null

