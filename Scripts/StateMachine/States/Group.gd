extends AState


var groups: Array = []

func enter() -> void :
	canvas._action_menu.hide()

func exit() -> void:
	canvas.snapshots.create_snapshot()

func input(_event: InputEvent) -> IState:
	print(typeof(canvas.Select_rect))
	if len(canvas.selected_lines) != 0:
	
		var elements: Array = canvas.Utils.map(canvas.selected_lines, canvas.Mimic, "get_first",[])
		elements = elements.slice(0,elements.size()-2)
		var positions = canvas.Utils.map(elements, canvas.Mimic, "area2D_position", [])
		var closure = canvas.Utils.get_positions_closure(positions)
		var center = canvas.Utils.get_positions_mean(closure)
		var transform := Transform2D()
		transform.origin = center
	
		var group := Area2D.new()
		group.name = "group" + str(groups.size())
		group.global_transform = transform
	
	# retrieve elements from selection
		var childs: Array = []
		var dup_child: Node
		for element in elements:
			for child in element.get_children():
				dup_child = child.duplicate(true)
				if child is CollisionShape2D:
					dup_child.global_transform = child.global_transform
					dup_child.global_transform.origin -= center
					group.add_child(dup_child)
				else:
					var new_area2D := Area2D.new()
					new_area2D.add_child(dup_child)
					new_area2D.global_transform = child.get_parent().global_transform
					new_area2D.global_transform.origin -= center
					group.add_child(new_area2D)
		
	# save ungroup elements
		groups.append(elements)
	
	#add group to scene
		canvas._elements.add_child(group)
	
	# remove child from element
		for element in elements:
			element.get_parent().remove_child(element)
	
	#add the group to selected_lines
		canvas.selected_lines = [[group,0],canvas.selected_lines[-1]]
	
	return switch_to_previous_state()

