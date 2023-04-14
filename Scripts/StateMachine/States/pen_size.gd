extends AState

func enter():
	_on_pen_size_pressed()

func input(event: InputEvent) -> IState:
	return switch_to_previous_state()
	
func _on_pen_size_pressed():
	canvas.pm.clear()
	canvas.pm.get_node("HSlider").value = canvas.linewidth
	canvas.pm.get_node("HSlider").visible = true
	canvas.pm.connect("id_pressed", canvas, "_on_Popucanvas.pmenu_id_pressed")

	var _text_popup = canvas.get_node("RightClickContainer/Pen size")
	canvas.pm.popup(Rect2(_text_popup.get_global_rect().position.x - 154, _text_popup.get_global_rect().position.y, 100, 100))
	canvas.pm.get_node("pensizecircle").set_line_size(canvas.linewidth)
	canvas.pm.get_node("pensizecircle").set_line_color(canvas.RCC.color)
	canvas.pm.get_node("pensizecircle").visible = true

func _on_HSlider_value_changed(value):
	canvas.pm.get_node("pensizecircle").set_line_size(value)
	canvas.linewidth = value
