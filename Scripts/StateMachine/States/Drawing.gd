extends IState

# Selection node to set with the Godot engine.
export (NodePath) var selection_node

onready var selection: IState = get_node(selection_node)


func input(event: InputEvent) -> IState:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				canvas.DrawLine()
			else:
				canvas._current_line.Curve2D_Transformer(canvas._camera)
	elif event is InputEventMouseMotion:
		if event.button_mask == BUTTON_MASK_LEFT:
			canvas._current_line._line.add_point(canvas.get_global_mouse_position())
	
	return null

func physics_process(delta: float) -> IState:
	return null


func _on_Selection_pressed():
	canvas.states.change_state(selection)
