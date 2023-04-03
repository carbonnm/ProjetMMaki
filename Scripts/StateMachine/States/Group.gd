extends AState

var ungroup: Node

func enter() -> void:
	canvas._action_menu.hide()
	ungroup = canvas.Snapshots.new(self, canvas.Utils.get_match_string_node("Elements", self))
	ungroup.create_snapshot()
#	input(null)
	
func exit() :
	canvas.snapshots.create_snapshot()

func input(event:InputEvent) -> IState: 
	var New_Group = Area2D.new()
	canvas._elements.add_child(New_Group)
	New_Group.name = "NewGroup"
	
	var element_to_copy = canvas.selected_lines.slice(0, canvas.selected_lines.size()-2)
	for element in element_to_copy :
#		var children = element[0].get_children()
#		for child in children :
#			child.get_parent().remove_child(child)
#			New_Group.add_child(child)
			
		if element[0] is Stroke:
			var _line = element[0].get_child(0).duplicate()
			element[0].get_parent().remove_child(element[0])
			New_Group.add_child(element[0])
			element[0]._line = _line
		
		if element[0] is Title:
			element[0].get_parent().remove_child(element[0])
			New_Group.add_child(element[0])
		
#			element[0]._line = element
	New_Group.position = New_Group.get_child(0).position
	for child in New_Group.get_children():
		child.position -= New_Group.position
		for shape in child.get_children():
			if shape is CollisionShape2D:
				child.remove_child(shape)
				New_Group.add_child(shape)
				
				shape.position += child.position
	
	CenterGroup(New_Group)
	
#		element[0].queue_free()
		
#		var children = element[0].get_children()
#		for shape in  children:
#			if shape is CollisionShape2D :
#				var duplicate_shape = shape.duplicate()
#				New_Group.add_child(duplicate_shape)
#	for element in element_to_copy :
#		element[0].queue_free()
	canvas.selected_lines = [[New_Group,0]]
	
	return switch_to_previous_state()


func CenterGroup(Group):
	var _shapes:Array = []
	
	for child in Group.get_children():
		if child is CollisionShape2D:
			_shapes.append(child)
	
	var Group_center = self.get_line2D_center(_shapes)
	Group.position += Group_center
	
	
	for child in Group.get_children():
		
		child.position -= Group_center
#		if child is Stroke:
#			child.position -= Group_center
##			var _shapes_points = []
##			for index in range(child._line.points.size()):
##				_shapes_points.append(child._line.points[index] - Group_center)
##
##			child._line.points = _shapes_points
#		elif child is Title:
#			child.rect_global_position -= Group_center

func get_line2D_center(shapes):
	var corners = get_line2D_corner(shapes)
	var upper_left = corners[0]
	var bottom_down = corners[1]
	return (upper_left+bottom_down)/2

func get_line2D_corner(shapes):
	var upper_left = Vector2.INF
	var bottom_right = -1*Vector2.INF
	for point in shapes:
		upper_left = Vector2(min(upper_left.x,point.position.x - (point.shape.extents.x / 2)),min(upper_left.y,point.position.y - (point.shape.extents.y / 2)))
		bottom_right = Vector2(max(bottom_right.x,point.position.x + (point.shape.extents.x / 2)),max(bottom_right.y,point.position.y + (point.shape.extents.y / 2)))
		
	return [upper_left,bottom_right]
