extends AState


func enter() -> void :
	canvas._action_menu.hide()

func exit() -> void :
	canvas.create_snapshot(canvas.snapshots)

func input(event: InputEvent) -> IState:
	if event is InputEventMouseMotion: 
		if event.button_mask == BUTTON_MASK_LEFT:
			var area2D_L = canvas.Utils.map(canvas.selected_lines,canvas.Mimic,"get_first",[])
			print(area2D_L)
			var mouse_position = canvas.get_global_mouse_position()
			var mouse_relative = event.relative
			canvas.Rotation.rotation(area2D_L,mouse_position,mouse_relative)
	
	return null
