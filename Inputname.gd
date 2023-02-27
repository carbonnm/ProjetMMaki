extends LineEdit


var new_name = ""
func _ready():
	pass


func _on_Inputname_text_entered(new_text):
	print(new_text)
	new_name = new_text
