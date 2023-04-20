extends AState

func enter() -> void:
	canvas._action_menu.hide()

func exit() -> void:
	canvas.snapshots.create_snapshot()

func input(event: InputEvent) -> IState:
	#yield(get_tree().create_timer(1.0), "timeout")
	if canvas.word_recognized == "":	
		var path = "ScreenShots/screenshot.png"
			
		var corners : Array = canvas.get_selection_area_corner()
		var upper_left : Vector2 = corners[0]
		canvas.drawing_position = upper_left
		var bottom_right : Vector2 = corners[1]
		var size_area : Vector2 = bottom_right - upper_left
		var _center_selected_lines = (bottom_right + upper_left)/2
		
		var margin : Vector2 = Vector2(50, 50)
		var capture_rect = Rect2(upper_left - margin, size_area + 2 * margin)
		
		var viewport = get_viewport() 
		var screenshot = viewport.get_texture().get_data()
		screenshot.flip_y()
		screenshot.get_rect(capture_rect).save_png(path)
		
		var word = canvas.word_recognition_python()
		canvas.word_recognized = word[0]
		
		var size_popup : Vector2 = canvas.get_node("PopUpMotConfirmation/ColorRect").get_global_rect().size
		
		canvas.get_node("PopUpMotConfirmation").rect_position = canvas._camera.get_camera_position() - (size_popup/5)
		canvas.get_node("PopUpMotConfirmation/Mot").text = word[0]
		canvas.get_node("PopUpMotConfirmation").visible = true
		
		canvas.delete_word()
		return null
		
	if canvas.get_node("ChoixImage").visible == true:
		return switch_to_previous_state()
		
	return null

func keyboard_input(event: InputEvent) -> IState:
	return null


