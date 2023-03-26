extends AState

func input(event: InputEvent) -> IState:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				canvas._camera.update_zoom(event, canvas._camera.ZOOMMIN)
			if event.button_index == BUTTON_WHEEL_DOWN:
				canvas._camera.update_zoom(event, canvas._camera.ZOOMMAX)
			
	if event is InputEventMouseMotion: 
		if event.button_mask == BUTTON_MASK_LEFT:
			# move the camera position relative to where the event input happen if Key_alt
			# is pressed (to work with laptop pads)
			if event.alt:
				canvas._camera.DragCamera(event.relative)
				
		# Move the camera position relative to where the event input happen
		if event.button_mask == BUTTON_MASK_MIDDLE:
			canvas._camera.DragCamera(event.relative)

	return null
