extends AState

func enter() -> void:
	canvas._action_menu.hide()

func exit() -> void:
	canvas.snapshots.create_snapshot()

func input(_event : InputEvent) -> IState:
	var ungrouped_groups: Array = get_node("../Group").groups	
	var elements: Array = canvas.Utils.map(canvas.selected_lines, canvas.Mimic, "get_first",[])
	

	for element in elements:
		if element.name.match("group"+"*"):
			var group_index: int = int(element.name.get_slice(5,element.name.length()-5))
			
			var groups: Array = ungrouped_groups[group_index]
			var positions = canvas.Utils.map(groups, canvas.Mimic, "area2D_position", [])
			var closure = canvas.Utils.get_positions_closure(positions)
			var center = canvas.Utils.get_positions_mean(closure)
			
			for elem in groups:
				canvas._elements.add_child(elem)
#				var transform: Transform2D = element.global_transform 
#				transform.origin -= center + elem.position
				var transform: Transform2D = element.global_transform
				transform.origin += (-center + elem.position)
				elem.global_transform = transform
				
			canvas._elements.remove_child(element)
	
	return switch_to_previous_state()
