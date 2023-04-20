extends Button

signal create_sub_sub_title_button(type)

func _on_CreateSubSubTitleButton_pressed():
	emit_signal("create_sub_sub_title_button", 3)
