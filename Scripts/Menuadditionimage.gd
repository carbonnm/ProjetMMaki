extends Node2D


func _ready():
	pass # Replace with function body.



func _on_Closebutton_mouse_exited():
	get_node("ColorRect/Closebutton/Crossicon").playing = false


func _on_Closebutton_mouse_entered():
	get_node("ColorRect/Closebutton/Crossicon").playing = true


func _on_Closebutton_button_up():
	get_node("Closebutton/Crossicon").playing = false
	visible = false

