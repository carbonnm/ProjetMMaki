extends AState

export var sensibility: float = 400.0

func enter() -> void:
	canvas._action_menu.hide()
	
func input(event: InputEvent) -> IState:
	var area2D_L = canvas.Utils.map(canvas.selected_lines,canvas.Mimic,"get_first",[])
	var mouse_position = canvas.get_global_mouse_position()
			
	if event is InputEventMouseButton:
		if not event.is_pressed():
			canvas.snapshots.create_snapshot()
			return self
			
	if event is InputEventMouseMotion: 
		if event.button_mask == BUTTON_MASK_LEFT:
			var mouse_relative = event.relative
			canvas.Rescale.rescale(area2D_L,mouse_position,mouse_relative)

	return null

func physics_process(delta: float) -> IState:
	var area2D_L = canvas.Utils.map(canvas.selected_lines,canvas.Mimic,"get_first",[])
	var mouse_position = canvas.get_global_mouse_position()
	var relative = delta*sensibility
	
	if Input.is_action_just_released("Zoom") or Input.is_action_just_released("Unzoom"):
		relative *= 2
	if Input.is_action_pressed("Zoom") or Input.is_action_just_released("Zoom"):
		canvas.Rescale.rescale(area2D_L,mouse_position,Vector2(1,1).normalized()*relative)
	elif Input.is_action_pressed("Unzoom") or Input.is_action_just_released("Unzoom"):
		canvas.Rescale.rescale(area2D_L,mouse_position,Vector2(-1,-1).normalized()*relative)
	
	return null

func keyboard_input(event: InputEvent) -> IState:
	var isWheelUp: bool = event.button_mask == BUTTON_WHEEL_UP
	var isWheelDown: bool = event.button_mask == BUTTON_WHEEL_DOWN

	if Input.is_action_just_released("Zoom") or Input.is_action_just_released("Unzoom"):
		if not (isWheelUp or isWheelDown):
			canvas.snapshots.create_snapshot()
			return self

	return null
