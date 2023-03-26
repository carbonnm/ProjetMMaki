extends AState


func enter() -> void:
	canvas._action_menu.hide()
	input(null)

func exit() -> void :
	canvas.create_snapshot(canvas.snapshots)

func input(event: InputEvent) -> IState:
	for area in canvas.selected_lines:
		area[0].queue_free()
		
	canvas.selected_lines.clear()
	
	return switch_to_previous_state()
