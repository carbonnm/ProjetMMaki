extends LineEdit


var new_name = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Inputname_text_entered(new_text):
	print(new_text)
	new_name = new_text
