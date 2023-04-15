extends AState

func enter() -> void:
	canvas._action_menu.hide()

func input(event : InputEvent) -> IState:
	var ungrouped_groups: Array = get_node("../Group").groups	
	var elements: Array = canvas.Utils.map(canvas.selected_lines, canvas.Mimic, "get_first",[])
	

	for element in elements:
		if element.name.match("group"+"*"):
			var group_index: int = int(element.name.get_slice(5,element.name.length()-5))
			
			canvas._elements.remove_child(element)
			for elem in ungrouped_groups[group_index]:
				canvas._elements.add_child(elem)
				
	
	
	return switch_to_previous_state()
