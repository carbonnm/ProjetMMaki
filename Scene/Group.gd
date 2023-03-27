extends AState

var ungroup : Dictionary = {
	"snapshots" : [],
	"current_index" : 0
}

func enter() -> void:
	canvas._action_menu.hide()
	ungroup = canvas.create_snapshot(ungroup)
#	input(null)
	
func exit() :
	canvas.create_snapshot(canvas.snapshots)

func input(event:InputEvent) -> IState: 
	
	var New_Group = Area2D.new()
	canvas._elements.add_child(New_Group)
	New_Group.name = "NewGroup"
	
	print(canvas.selected_lines)
	var element_to_copy = canvas.selected_lines.slice(0, canvas.selected_lines.size()-2)
	print("copy",element_to_copy)
	for element in element_to_copy :
		print("copyinloop",element_to_copy)
#		var children = element[0].get_children()
#		for child in children :
#			child.get_parent().remove_child(child)
#			New_Group.add_child(child)
			
		if element[0] is Stroke:
			print("IsStroke")
			var _line = element[0].get_child(0).duplicate()
			element[0].get_parent().remove_child(element[0])
			New_Group.add_child(element[0])
			element[0]._line = _line
		
		if element[0] is Title:
			print("IsTitle")
			element[0].get_parent().remove_child(element[0])
			New_Group.add_child(element[0])
			
	New_Group.position = New_Group.get_child(0).position
	for child in New_Group.get_children():
		child.position -= New_Group.position
		for shape in child.get_children():
			if shape is CollisionShape2D:
				child.remove_child(shape)
				New_Group.add_child(shape)
				
				shape.position += child.position
	
	CenterGroup(New_Group)
	canvas.selected_lines = [[New_Group,0]]
	print("select",canvas.selected_lines)
	print("new_group.position",New_Group.position)
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
##			print("STROKE")
##			var _shapes_points = []
##			for index in range(child._line.points.size()):
##				_shapes_points.append(child._line.points[index] - Group_center)
##			print(child._line.points)
##
##			child._line.points = _shapes_points
##			print(child._line.points)
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
