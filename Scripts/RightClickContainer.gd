class_name RightClickContainer
extends VBoxContainer

var color := Color.white
var color_picker := false
onready var screen_size_x : int = $"../../BackgroundColored".rect_size.x
onready var screen_size_y : int = $"../../BackgroundColored".rect_size.y
export (Vector2) var right_click_position

func _ready() -> void:
	color = $ColorPickerButton.color
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_RIGHT:
				if get_node("../ActionMenu").visible == true :
					get_node("../ActionMenu").visible = false
					get_node("../..").selected_lines.clear()
					#get_node("../..").Select_rect.free()
					get_node("../..").Selection_area.free()
				right_click_position = get_global_mouse_position()
				#print(right_click_position)
				var mouse_position : Vector2 = get_global_mouse_position()
				if mouse_position.x > screen_size_x - rect_size.x and mouse_position.y > screen_size_y - rect_size.y :
					rect_position.x = mouse_position.x - rect_size.x
					rect_position.y = screen_size_y - rect_size.y
				elif mouse_position.y > screen_size_y - rect_size.y :
					rect_position.x = mouse_position.x
					rect_position.y = screen_size_y - rect_size.y
				elif mouse_position.x > screen_size_x - rect_size.x :
					rect_position.x = screen_size_x - rect_size.x
					rect_position.y = mouse_position.y
				else : 
					rect_position = mouse_position
#				self.rect_scale = Vector2(get_parent().get_parent()._camera.zoom.x, get_parent().get_parent()._camera.zoom.y)
				show()
			if event.button_index == BUTTON_LEFT:
				if color_picker:
					return

				var mouse_pos = get_global_mouse_position()

				# Check if the mouse input is outside of the
				# boundaries of the container
				var left = mouse_pos.x < rect_position.x
				var right = mouse_pos.x > rect_position.x + rect_size.x
				var top = mouse_pos.y < rect_position.y
				var bottom = mouse_pos.y > rect_position.y + rect_size.y

				if left || right || top || bottom:
					hide()
					$"../TitleCreationPopUp".hide()


func _on_ColorPickerButton_color_changed(_color: Color) -> void:
	color = _color
	$ColorPickerButton.color = _color
	$"../Panel2/VBoxContainer/ColorPickerButton".color = _color


func _on_ColorPickerButton_pressed() -> void:
	color_picker = true


func _on_ColorPickerButton_popup_closed() -> void:
	color_picker = false
	hide()
	
