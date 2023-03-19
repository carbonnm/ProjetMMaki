extends AState


func enter():
	#handles the first undo (to initialize index_created following the nulber of created elements
	if canvas.notyetundo and canvas.commands.size()>0:
		canvas.notyetundo = false
		canvas.index_created = canvas.created_elements.size()-1
		canvas.index_command = canvas.commands.size()-1
		
	#handles the undo if last operation was a line or text creation
	if canvas.commands[canvas.index_command] == "creation" and canvas.index_created>=-1 and canvas.created_elements.size()>0:		
		var to_delete = canvas.created_elements[canvas.index_created]
		#opened to better solution 
		canvas.to_delete.visible = false
		canvas.index_created -=1	
		
	#handles the undo if last operation was a delete on a selection
	#(makes them visible again)
	if canvas.commands[canvas.index_command] == "delete":
		for element in canvas.deleted[canvas.index_deleted]:
			element.visible = true

func input(event: InputEvent) -> IState:
	return null

func physics_process(_delta: float) -> IState:
	return null
