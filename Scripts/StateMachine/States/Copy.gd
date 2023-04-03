extends AState

var copied_lines: Array

func enter() -> void:
	canvas._action_menu.hide()
	
func input(event: InputEvent) -> IState:
	if canvas.selected_lines != []:
		copied_lines = canvas.selected_lines.duplicate(true)
	return switch_to_previous_state()
