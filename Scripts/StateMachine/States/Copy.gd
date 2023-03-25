extends AState

var copied_lines: Array

func enter():
	canvas._action_menu.hide()
	copied_lines = canvas.selected_lines.duplicate()
