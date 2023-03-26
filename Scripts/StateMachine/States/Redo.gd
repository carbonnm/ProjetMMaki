extends AState


func enter() -> void:
	canvas._action_menu.hide()
	input(null)

func input(event: InputEvent) -> IState:
	if event is InputEventKey:
		if event.scancode == KEY_Y and Input.is_key_pressed(KEY_CONTROL):
			canvas.reload_snapshot(canvas.snapshots["current_index"]+1,canvas.snapshots)
	return null

func physics_process(_delta: float) -> IState:
	return null
