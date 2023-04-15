extends AState


var groups: Array = []


func input(event: InputEvent) -> IState:
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
	for element in elements:
		childs += element.get_children()

		
		
	# save ungroup elements
	groups.append(childs)
	
	# add childs to group
	for child in childs:
		var child_copy = child.duplicate(true)
		child_copy.global_transform= child.global_transform
		child_copy.position -= center
		group.add_child(child_copy)
	
	#add group to scene
	canvas._elements.add_child(group)
	
	# remove child from element
	for element in elements:
		element.get_parent().remove_child(element)
	
	#add the group to selected_lines
	canvas.selected_lines = [[group,0],canvas.selected_lines[-1]]
	return switch_to_previous_state()

