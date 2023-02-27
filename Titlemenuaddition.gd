extends Node2D


func _ready():
	pass 

#gets what's been entered in the input field on button pressed
#No need to press Enter anymore
func _on_Titleinputbutton_pressed():
	print(get_node("Inputtitle").chosen)
