extends Node2D

# Signal to communicate what title has been chosen
signal new_title(chosen_title)
var chosen_title = ""
var type_title

func _ready():
	#changes the appearance of the title menu addition following what's being created
	if(type_title == 1):
		get_node("Titlemenu").visible  = true
		get_node("Subtitlemenu").visible  = false
		get_node("Subsubtitlemenu").visible  = false
	if(type_title == 2):
		get_node("Subtitlemenu").visible  = true
		get_node("Subsubtitlemenu").visible  = false
		get_node("Titlemenu").visible  = false
	if(type_title == 3):
		get_node("Subsubtitlemenu").visible  = true
		get_node("Titlemenu").visible  = false
		get_node("Subtitlemenu").visible  = false
	

#gets what's been entered in the input field on button pressed

func _on_Titleinputbutton_pressed():
	chosen_title = get_node("Inputtitle").chosen
	
	# Emit the signals
	emit_signal("new_title",chosen_title)



func _on_Exit_button_pressed():
	visible = false
