extends Node

# Starting state to set with the Godot engine.
export (NodePath) var starting_state

var current_state: IState

"""
Initialize the state manager with the starting state.

Parameters:
-----------
canvas: The parent of the node. (Canvas)
"""
func init(canvas: Canvas) -> void:
	for child in get_children():
		child.canvas = canvas
	
	change_state(get_node(starting_state))

"""
Function called every physics frame (every time the physic engine update). It
applies physics-based logic to the parent node according to the current state
and refresh the current state afterward.

Parameters:
-----------
delta: The time elipsed since the last physics frame, in seconds. (float)
"""
func physics_process(delta: float) -> void:
	var new_state = current_state.physics_process(delta)
	if new_state:
		change_state(new_state)

"""
Function called to consume an input event on the parent node according to the
current state.

Parameters:
-----------
event: The input event to consume. (InputEvent)
"""
func input(event: InputEvent) -> void:
	var new_state = current_state.input(event)
	if new_state:
		change_state(new_state)

"""
Update the state of the state manager.

Parameters:
-----------
new_state: The new state to assign to the state manager. (IState)
"""
func change_state(new_state: IState) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
