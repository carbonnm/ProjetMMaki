class_name AState
extends IState

# Selection nodes to set with the Godot engine.
export (NodePath) var signal_switcher_node

onready var signal_switcher: IState = get_node(signal_switcher_node)

func input(event: InputEvent) -> IState:
	return signal_switcher.input(event)

func physics_process(delta: float) -> IState:
	return signal_switcher.physics_process(delta)

func parametrized_call(args: Array) -> IState:
	return signal_switcher.parametrized_call(args)

func switch_signal(state: String) -> IState:
	return signal_switcher.switch_signal(state)

func switch_to_previous_state() -> IState:
	return signal_switcher.switch_to_previous_state()

func keyboard_input(event: InputEvent) -> IState:
	return signal_switcher.keyboard_input(event)
