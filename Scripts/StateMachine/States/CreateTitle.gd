extends AState


func parametrized_call(args: Array) -> IState:
	canvas.create_new_title(args[0])
	return switch_to_previous_state()
