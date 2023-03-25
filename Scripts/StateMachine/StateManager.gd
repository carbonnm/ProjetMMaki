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
	var children: Array = get_children()
	while (children.size() != 0):
		children[-1].canvas = canvas
		children = children[-1].get_children() + children
		children.pop_back()
			
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
	var interrupt_state = get_node("SignalSwitcher").input(event)
	var sleeping_state = current_state
	if interrupt_state:
		current_state = interrupt_state
	
	var new_state = current_state.input(event)
	if new_state:
		change_state(new_state)
	elif sleeping_state:
		current_state = sleeping_state

func switch_signal(state: String) -> void:
	var new_state = current_state.switch_signal(state)
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
	print(current_state)
	current_state.enter()


func _on_Selection_pressed():
	switch_signal("Selection")

func _on_Drawing_pressed():
	switch_signal("Drawing")

func _on_Copy_pressed():
	switch_signal("Copy")

func _on_Paste_pressed():
	switch_signal("Paste")

func _on_Drag_And_Drop_pressed():
	switch_signal("DragAndDrop")

func _on_Rescale_pressed():
	switch_signal("Rescale")

func _on_Rotation_pressed():
	switch_signal("Rotation")

func _on_Delete_pressed():
	switch_signal("Delete")

func _on_MoveCanvas_pressed():
	switch_signal("MoveCanvas")
