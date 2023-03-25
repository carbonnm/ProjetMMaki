extends AState

func enter():
	canvas._action_menu.hide()

func input(event: InputEvent) -> IState:
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		var clines = canvas.Utils.map(get_node("../Copy").copied_lines,canvas.Mimic,"get_first",[])
		var clines_positions = canvas.Utils.map(clines, canvas.Mimic, "area2D_position", [])
		var closure = canvas.Utils.get_positions_closure(clines_positions)
		var center = canvas.Utils.get_positions_mean(closure)
		var translation = -center + canvas.get_global_mouse_position()
		
		for Ligne in clines:
			var duplarea = Ligne.duplicate()
		
			duplarea.position += translation
			canvas._elements.add_child(duplarea)
		
			if duplarea is Stroke:
				duplarea._line = duplarea.get_child(0)
			
	return null

func physics_process(_delta: float) -> IState:
	return null
