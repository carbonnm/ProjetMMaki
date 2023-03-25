extends AState


func enter() -> void:
	canvas._action_menu.hide()
	
func exit() -> void:
	canvas.create_snapshot(canvas.snapshots)

func input(event: InputEvent) -> IState:
	if event is InputEventMouseMotion: 
		if event.button_mask == BUTTON_MASK_LEFT:
			var area2D_L = canvas.Utils.map(canvas.selected_lines,canvas.Mimic,"get_first",[])
			var mouse_relative = event.relative
			canvas.DragAndDrop.drag_and_drop(area2D_L,mouse_relative)
			
			#canvas.snapshots = canvas.create_snapshot(canvas.snapshots)
	return null

func physics_process(_delta: float) -> IState:
	return null
