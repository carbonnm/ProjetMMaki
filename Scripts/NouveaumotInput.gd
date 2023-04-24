extends LineEdit


var new_name = ""

func _ready():
	grab_focus()

#keeps up with the changes of the input field
func _on_NouveaumotInput_text_changed(new_text):
	new_name = new_text
