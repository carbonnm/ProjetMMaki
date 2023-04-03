extends Panel




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Closebutton_button_up():
	get_node("Closebutton/Crossicon").playing = false
	visible = false


func _on_Okbutton_button_up():
	
	var name_entered = $Themenameinput.new_theme_name 
	
	if(name_entered ==""):
		$Themenamenotentered.visible = true
	else:
		visible = false
		$Themenamenotentered.visible = false
		$Themenameinput.text = ""

func _on_Closebutton_mouse_entered():
	get_node("Closebutton/Crossicon").playing = true




func _on_Closebutton_mouse_exited():
	get_node("Closebutton/Crossicon").playing = false




func _on_Okbutton_mouse_entered():
	get_node("Okbutton/Checkmarkicon").playing = true

func _on_Okbutton_mouse_exited():
	get_node("Okbutton/Checkmarkicon").playing = false
