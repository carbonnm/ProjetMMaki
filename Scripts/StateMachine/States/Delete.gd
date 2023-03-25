extends AState


func enter() -> void:
	canvas._action_menu.hide()
	for area in canvas.selected_lines:
		area[0].queue_free()
		
	canvas.selected_lines.clear()
	canvas._action_menu.hide()
	#emit_signal("Line_count",0)
	#Updates elements counter 
	canvas._linecounter.Count = str(canvas._elements.get_child_count())


func exit() -> void :
	canvas.create_snapshot(canvas.snapshots)
