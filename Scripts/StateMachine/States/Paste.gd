extends AState

func enter() -> void:
	canvas.detached_RCC.hide()

func exit() -> void:
	canvas.snapshots.create_snapshot()

func input(event: InputEvent) -> IState:
	var clines = canvas.Utils.map(get_node("../Copy").copied_lines,canvas.Mimic,"get_first",[])
	var clines_positions = canvas.Utils.map(clines, canvas.Mimic, "area2D_position", [])
	var closure = canvas.Utils.get_positions_closure(clines_positions)
	var center = canvas.Utils.get_positions_mean(closure)
	var translation = -center + canvas.detached_RCC.rect_position
	
	for Ligne in clines:
		var duplarea = Ligne.duplicate(true)
		duplarea.position += translation
		canvas._elements.add_child(duplarea)
	
		if duplarea is Stroke:
			duplarea._line = duplarea.get_child(0)
	
	return switch_to_previous_state()
