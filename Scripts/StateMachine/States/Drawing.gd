extends AState

var _current_line: Area2D


func input(event: InputEvent) -> IState:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				_current_line = canvas.DrawLine(_current_line)
			else:
				_current_line.Curve2D_Transformer(canvas._camera)
				
	elif event is InputEventMouseMotion:
		if event.button_mask == BUTTON_MASK_LEFT:
			_current_line._line.add_point(canvas.get_global_mouse_position())
	
	return null

func physics_process(_delta: float) -> IState:
	return null

