extends Button

signal create_sub_title_button(type)

func _on_CreateSubTitleButton_pressed():
	emit_signal("create_sub_title_button", 2)
