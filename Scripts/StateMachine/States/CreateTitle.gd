extends AState

func exit() -> void:
	canvas.snapshots.create_snapshot()

func input(event: InputEvent) -> IState:
	
	if Input.is_action_pressed("1"):
		canvas._on_PopupMenu_id_pressed(1)
	elif Input.is_action_pressed("2"):
		canvas._on_PopupMenu_id_pressed(2)
	elif Input.is_action_pressed("3"):
		canvas._on_PopupMenu_id_pressed(3)
	
	return null

func parametrized_call(args: Array) -> IState:
	canvas.CreateTitle.create_new_title(args[0], canvas.custom.customization, canvas)
	return switch_to_previous_state()

func keyboard_input(event: InputEvent) -> IState:
	var TMA: Control = canvas.get_node("Titlemenuaddition")
	if TMA.visible:
		if Input.is_action_just_pressed("ui_cancel"):
			canvas.get_node("Titlemenuaddition").hide()
			return switch_to_previous_state()
		
		return null
	
	return .keyboard_input(event)
