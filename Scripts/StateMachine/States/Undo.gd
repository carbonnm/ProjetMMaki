extends AState


func enter() -> void:
	canvas._action_menu.hide()

func input(event: InputEvent) -> IState:
	if event is InputEventKey:
		if event.scancode == KEY_Z and Input.is_key_pressed(KEY_CONTROL):
			canvas._elements = canvas.snapshots.get_last_snapshot()
			
	return switch_to_previous_state()
