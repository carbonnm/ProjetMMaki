extends Node2D

# Signal to communicate what title has been chosen
signal new_title(chosen_title)
var chosen_title = ""

var type_title 


func _ready():
	pass
	

#gets what's been entered in the input field on button pressed

func _on_Titleinputbutton_pressed():
	chosen_title = get_node("Inputtitle").chosen
	
	if chosen_title == "" :
		return
	# Emit the signals
	emit_signal("new_title",chosen_title)

func _on_Exit_button_pressed():
	visible = false


func _on_Inputtitle_text_entered(new_text: String) -> void:
	_on_Titleinputbutton_pressed()
