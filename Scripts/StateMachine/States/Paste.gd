extends AState

func enter():
	canvas._action_menu.hide()
	var clines = canvas.Utils.map(canvas.copied_lines,canvas.Mimic,"get_first",[])
	var clines_positions = canvas.Utils.map(clines, canvas.Mimic, "area2D_position", [])
	var closure = canvas.Utils.get_positions_closure(clines_positions)
	var center = canvas.Utils.get_positions_mean(closure)
	var translation = -center + canvas.RCC.rect_position
	
	for Ligne in clines:
		var duplarea = Ligne.duplicate()
	
		duplarea.position += translation
		canvas._lines.add_child(duplarea)
	
		if duplarea is Stroke:
			duplarea._line = duplarea.get_child(0)

func input(event: InputEvent) -> IState:
	return null

func physics_process(_delta: float) -> IState:
	return null
