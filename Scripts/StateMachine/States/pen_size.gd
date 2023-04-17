extends AState

func input(event: InputEvent) -> IState:
	canvas.pm.clear()
	canvas.pm.get_node("HSlider").value = canvas.linewidth
	canvas.pm.get_node("HSlider").visible = true
	canvas.pm.connect("id_pressed", canvas, "_on_Popucanvas.pmenu_id_pressed")

	var _text_popup = canvas.get_node("RightClickContainer/Pen size")
	canvas.pm.popup(Rect2(_text_popup.get_global_rect().position.x - 154, _text_popup.get_global_rect().position.y, 100, 100))
	canvas.pm.get_node("pensizecircle").set_line_size(canvas.linewidth)
	canvas.pm.get_node("pensizecircle").set_line_color(canvas.RCC.color)
	canvas.pm.get_node("pensizecircle").visible = true
	
	return switch_to_previous_state()

func parametrized_call(args: Array) -> IState:
	canvas.pm.get_node("pensizecircle").set_line_size(args[0])
	canvas.linewidth = args[0]
	
	return switch_to_previous_state()
