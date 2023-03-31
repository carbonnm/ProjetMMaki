extends Panel



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_BoutonUNamur_pressed():
	print("test")
	#$UNamur_theme.bbcode_text = "[shake] Thème UNamur [/shake]"
	


func _on_BoutonUNamur_mouse_entered():
	$UNamur_theme.bbcode_text = "[shake]Thème UNamur [/shake]"


func _on_BoutonUNamur_mouse_exited():
	$UNamur_theme.bbcode_text = "Thème UNamur "


func _on_Closebutton_button_up():
	get_node("Closebutton/Crossicon").playing = false
	visible = false


func _on_Closebutton_mouse_entered():
	get_node("Closebutton/Crossicon").playing = true


func _on_Closebutton_mouse_exited():
	get_node("Closebutton/Crossicon").playing = false
