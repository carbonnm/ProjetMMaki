extends Control

func _on_exitButton_pressed():
	visible = false


func _on_okButton_pressed():
	visible = false
	get_node("../ChoixImage").visible = true
