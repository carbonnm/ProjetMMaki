extends AState

func enter() -> void:
	Input.set_custom_mouse_cursor(load("res://Assets/Graphics/Image/hand-regular.svg"))

func exit() -> void:
	Input.set_custom_mouse_cursor(load("res://Assets/Graphics/Image/arrow-pointer-solid.svg"))

func input(event: InputEvent) -> IState:
	if event is InputEventMouseMotion:
		if event.button_mask == BUTTON_MASK_LEFT or event.button_mask == BUTTON_MASK_MIDDLE:
			canvas._camera.DragCamera(event.relative)
			
	return null

func keyboard_input(_event: InputEvent) -> IState:
	if Input.is_action_just_released("MoveCanvas"):
		return switch_to_previous_state()
	
	return null
