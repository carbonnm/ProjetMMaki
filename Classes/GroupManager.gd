extends AState


var groups: Array = []


func input(event: InputEvent) -> IState:
	var elements: Array = canvas.Utils.map(canvas.selected_lines, canvas.Mimic, "get_first",[])
	elements = elements.slice(0,elements.size()-2)
	
	var group := Area2D.new()
	group.name = "group" + str(groups.size()-1)
	
	# retrieve elements from selection
	var childs: Array = []
	for element in elements:
		childs += element.get_children()
		element.get_parent().remove_child(element)
		
		
	# save ungroup elements
	groups.append(childs)
	
	# add childs to group
	for child in childs:
		var child_copy = child.duplicate(true)
		group.add_child(child_copy)
	
	#add group to scene
	canvas._elements.add_child(group)
	
	return switch_to_previous_state()

