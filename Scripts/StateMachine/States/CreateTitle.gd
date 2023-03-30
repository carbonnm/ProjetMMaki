extends AState

func exit() -> void:
	canvas.snapshots.create_snapshot()

func parametrized_call(args: Array) -> IState:
	canvas.CreateTitle.create_new_title(args[0], canvas.custom.customization, canvas)
	return switch_to_previous_state()
