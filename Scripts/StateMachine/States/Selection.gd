extends AState

# A change of state during an action cause an interruption of the action 
# (change could be caused by a signal).
var interruption: bool = false


func input(event: InputEvent) -> IState:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				interruption = true
				canvas.DrawSelectionArea()
		else:
			if canvas.Select_rect:
				canvas.Select_rect.queue_free()
				
			interruption = false
			
	elif  event is InputEventMouseMotion:
		if event.button_mask == BUTTON_MASK_LEFT:
			canvas.UpdateSelectionArea()
	
	return null

func physics_process(_delta: float) -> IState:
	return null
