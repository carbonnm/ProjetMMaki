extends Control


func _on_exitButton_pressed():
	visible = false


func _on_okButton_pressed():
	visible = false
	var size_pop_up : Vector2 = get_node("../ChoixImage/ColorRect").get_global_rect().size
	get_node("../ChoixImage").rect_position = get_node("../Camera").get_camera_position() - size_pop_up - Vector2(120, -200)
	get_node("../ChoixImage").visible = true


func _on_modifyButton_pressed():
	visible = false
	var size_pop_up : Vector2 = get_node("../ModificationWord/ColorRect").get_global_rect().size
	get_node("../ModificationWord").rect_position = get_node("../Camera").get_camera_position() - size_pop_up + Vector2(200, 100)
	get_node("../ModificationWord").visible = true
