extends AState

func enter():
	canvas._action_menu.hide()
	
	var clines = canvas.Utils.map(get_node("../Copy").copied_lines,canvas.Mimic,"get_first",[])
	var clines_positions = canvas.Utils.map(clines, canvas.Mimic, "area2D_position", [])
	var closure = canvas.Utils.get_positions_closure(clines_positions)
	var center = canvas.Utils.get_positions_mean(closure)
	var translation = -center + canvas.detached_RCC.rect_position
	
	for Ligne in clines:
		var duplarea = Ligne.duplicate()
		duplarea.position += translation
		canvas._elements.add_child(duplarea)
	
		if duplarea is Stroke:
			duplarea._line = duplarea.get_child(0)

	canvas.create_snapshot(canvas.snapshots)
