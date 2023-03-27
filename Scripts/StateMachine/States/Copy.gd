extends AState

var copied_lines: Array

func enter() -> void:
	canvas._action_menu.hide()
#	input(null)
	
func input(event: InputEvent) -> IState:
	if canvas.selected_lines != []:
		copied_lines = canvas.selected_lines.duplicate()
		copied_lines.resize(canvas.selected_lines.size()-1)
	return switch_to_previous_state()
