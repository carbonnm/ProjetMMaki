extends IState

# Selection node to set with the Godot engine.
export (NodePath) var drawing_node

onready var drawing: IState = get_node(drawing_node)


func input(event: InputEvent) -> IState:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				canvas.DrawSelectionArea()
		else:
			if canvas.Select_rect:
				canvas.Select_rect.queue_free()
	elif  event is InputEventMouseMotion:
		if event.button_mask == BUTTON_MASK_LEFT:
			canvas.UpdateSelectionArea()
	
	return null

func physics_process(delta: float) -> IState:
	return null

func _on_Drawing_pressed():
	canvas.states.change_state(drawing)
