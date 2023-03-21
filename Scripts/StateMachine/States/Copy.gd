extends AState

func enter():
	canvas._action_menu.hide()
	canvas.copied_lines = canvas.selected_lines.duplicate()
