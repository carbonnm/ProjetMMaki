extends Node

# Starting state to set with the Godot engine.
export (NodePath) var starting_state

var current_state: IState
var previous_state: IState

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
	previous_state = current_state

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
Function called to consume an background input event on the parent node 
according to the current state.

Parameters:
-----------
event: The input event to consume. (InputEvent)
"""
func input(event: InputEvent) -> void:
	var new_state = current_state.input(event)
	if new_state:
		change_state(new_state)

"""
Function called to consume a keyboard input event on the parent node according 
to the current state.

Parameters:
-----------
event: The input event to consume. (InputEvent)
"""
func keyboard_input(event: InputEvent) -> void:
	var interrupt_state = current_state.keyboard_input(event)
	if interrupt_state:
		var sleeping_state = current_state
		previous_state = sleeping_state
		change_state(interrupt_state)
		
		var new_state = current_state.input(event)
		if new_state:
			change_state(new_state)
			#("Interupted: ", sleeping_state, " - by: ", interrupt_state, " - Back to: ", interrupt_state)

"""
Function called to consume a switch signal on the parent node according to the 
current state.

Parameters:
-----------
state: The state to switch to. (String)
"""
func switch_signal(state: String) -> void:
	var new_state = current_state.switch_signal(state)
	if new_state:
		change_state(new_state)
		new_state = current_state.input(null)
		if new_state:
			change_state(new_state)

"""
Function called to consume a switch signal with an argument on the parent node 
according to the current state.

Parameters:
-----------
state: The state to switch to. (String)
args: An array containing arguments. (Array)
"""
func switch_signal_with_arguments(state: String, args: Array) -> void:
	var new_state = current_state.switch_signal(state)
	if new_state:
		change_state(new_state)
		new_state = current_state.parametrized_call(args)
		if new_state:
			change_state(new_state)

"""
Function called to switch to the previous state.
"""
func switch_to_previous_state() -> void:
	var new_state = current_state.switch_to_previous_state()
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
	#print("Previous State : ", previous_state, " - Current State : ", current_state)


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

func _on_Group_pressed():
	switch_signal("Group")

func _on_Ungroup_pressed():
	switch_signal("Ungroup")

func _on_Fusion_pressed():
	switch_signal("Fusion")

func _on_Pen_Size_pressed():
	switch_signal("PenSize")

func _on_Titlemenuaddition_new_title(chosen_title):
	switch_signal_with_arguments("CreateTitle", [chosen_title])





func _on_PopupMenu_popup_hide():
	pass # Replace with function body.
