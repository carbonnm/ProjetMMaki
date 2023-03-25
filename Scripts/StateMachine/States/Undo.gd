extends AState


func input(event: InputEvent) -> IState:
	print("so in undo")
	if event is InputEventKey:
		if event.scancode == KEY_Z and Input.is_key_pressed(KEY_CONTROL):
			print("before snapshot")
			canvas.reload_snapshot(canvas.snapshots["current_index"]-1,canvas.snapshots)
	return null

func physics_process(_delta: float) -> IState:
	return null
