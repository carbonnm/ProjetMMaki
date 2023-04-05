extends AState

export var sensibility: float = 300.0

func enter() -> void:
	canvas._action_menu.hide()

func exit() -> void:
	canvas.snapshots.create_snapshot()

func input(event: InputEvent) -> IState:
	var area2D_L = canvas.Utils.map(canvas.selected_lines,canvas.Mimic,"get_first",[])
		
	if event is InputEventMouseButton:
		if not event.is_pressed() and event.button_mask == BUTTON_MASK_LEFT and not Input.is_action_pressed("DragAndDrop"):
			return self
			
	if event is InputEventMouseMotion: 
		if event.button_mask == BUTTON_MASK_LEFT:
			var mouse_relative = event.relative
			canvas.DragAndDrop.drag_and_drop(area2D_L,mouse_relative)
			
	return null

func physics_process(delta: float) -> IState:
	var area2D_L = canvas.Utils.map(canvas.selected_lines,canvas.Mimic,"get_first",[])
	
	if not area2D_L:
		return null
	
	var isUp: bool = Input.is_action_pressed("ui_up")
	var isRight: bool = Input.is_action_pressed("ui_right")
	var isDown: bool = Input.is_action_pressed("ui_down")
	var isLeft: bool = Input.is_action_pressed("ui_left")
	
	var direction: Vector2 = Vector2(
		canvas.Utils.bool_to_int(isRight)-canvas.Utils.bool_to_int(isLeft),
		canvas.Utils.bool_to_int(isDown)-canvas.Utils.bool_to_int(isUp))
	direction = direction.normalized()
	
	canvas.DragAndDrop.drag_and_drop(area2D_L,direction*delta*sensibility)

	return null

func keyboard_input(event: InputEvent) -> IState:
	
	if Input.is_action_just_released("DragAndDrop") and not Input.is_action_pressed("DragAndDrop"):
		exit()
		return switch_to_previous_state()
	
	if Input.is_action_just_released("ui_accept"):
		exit()
		return switch_to_previous_state()
	
	return null
