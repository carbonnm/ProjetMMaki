extends AState


func enter():
	if not canvas.notyetundo and canvas.index_created<canvas.created_elements.size()-1:
		var to_recreate = canvas.created_elements[canvas.index_created]
		to_recreate.visible = true
		canvas.index_created += 1

func input(event: InputEvent) -> IState:
	return null

func physics_process(_delta: float) -> IState:
	return null
