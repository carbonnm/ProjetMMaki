extends AState


func enter() -> void:
	canvas._action_menu.hide()

func exit() -> void :
	canvas.snapshots.create_snapshot()

func input(event: InputEvent) -> IState:
	for area in canvas.selected_lines:
		area[0].queue_free()
		
	canvas.selected_lines.clear()
	
	return switch_to_previous_state()
