extends AState

func enter():
	canvas._action_menu.hide()
	canvas.copied_lines = canvas.selected_lines.duplicate()

func input(event: InputEvent) -> IState:
	return null

func physics_process(_delta: float) -> IState:
	return null
