extends AState

# A change of state during an action cause an interruption of the action 
# (change could be caused by a signal).
var interruption: bool = false


func input(event: InputEvent) -> IState:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				interruption = true
				canvas.DrawLine()
			else:
				canvas._current_line.Curve2D_Transformer(canvas._camera)
				interruption = false
				
	elif event is InputEventMouseMotion:
		if event.button_mask == BUTTON_MASK_LEFT:
			canvas._current_line._line.add_point(canvas.get_global_mouse_position())
	
	return null

func physics_process(_delta: float) -> IState:
	return null

