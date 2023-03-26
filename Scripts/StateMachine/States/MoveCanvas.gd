extends AState

func enter() -> void:
	Input.set_custom_mouse_cursor(load("res://Assets/Graphics/Image/hand-regular.svg"))

func input(event: InputEvent) -> IState:
	if event is InputEventMouseMotion && event.button_mask == BUTTON_MASK_LEFT:
		canvas._camera.DragCamera(event.relative)

	return null
