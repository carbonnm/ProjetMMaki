extends Node

export (NodePath) var starting_state

var current_state: IState


func change_state(new_state: IState) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()

func init(canvas: Canvas) -> void:
	for child in get_children():
		child.canvas = canvas
	
	change_state(get_node(starting_state))

func _physics_process(delta: float) -> void:
	var new_state = current_state.physics_process(delta)
	if new_state:
		change_state(new_state)

func input(event: InputEvent) -> void:
	var new_state = current_state.input(event)
	if new_state:
		change_state(new_state)





