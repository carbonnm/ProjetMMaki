extends AState


func enter():
	canvas._action_menu.hide()
	for area in canvas.selected_lines:
		area[0].visible = false
		canvas.commands.append("delete")
		canvas.deleted.append([])
		canvas.deleted[canvas.index_deleted].append(area[0])
		
		
	canvas.selected_lines.clear()
	canvas._action_menu.hide()
	#emit_signal("Line_count",0)
	#Updates elements counter 
	canvas._linecounter.Count = str(canvas._lines.get_child_count())

func input(event: InputEvent) -> IState:
	return null

func physics_process(_delta: float) -> IState:
	return null
