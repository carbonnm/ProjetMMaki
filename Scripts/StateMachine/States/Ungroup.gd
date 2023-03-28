extends AState

func enter() -> void:
	canvas._action_menu.hide()

func input(event : InputEvent) -> IState:
	var ungroup = get_node("../Group").ungroup
	canvas.reload_snapshot(ungroup["current_index"],ungroup)
	
	return switch_to_previous_state()
