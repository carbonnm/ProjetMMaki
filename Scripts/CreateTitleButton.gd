extends Button

signal create_title_button(type)

func _on_CreateTitleButton_pressed():
	emit_signal("create_title_button", 1)
