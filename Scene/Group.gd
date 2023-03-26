extends AState

var ungroup : Dictionary = {
	"snapshots" : [],
	"current_index" : 0
}

func enter() -> void:
	canvas._action_menu.hide()	
	input(null)
	
func exit() :
	canvas.create_snapshot(canvas.snapshots)

func input(event:InputEvent) -> IState: 
	ungroup = canvas.create_snapshot(ungroup)
	
	var New_Group = Area2D.new()
	canvas._elements.add_child(New_Group)
	
	var element_to_copy = canvas.selected_lines.slice(0, canvas.selected_lines.size()-1)
	for element in element_to_copy :
		element[0].get_parent().remove_child(element[0])
		New_Group.add_child(element[0])
		
		var children = element[0].get_children()
		for shape in  children:
			if shape is CollisionShape2D :
				var duplicate_shape = shape.duplicate()
				New_Group.add_child(duplicate_shape)
	return switch_to_previous_state()




