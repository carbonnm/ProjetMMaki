extends Control

var modified_word : String = ""
signal modified(modified_word)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Titleinputbutton_pressed():
	modified_word = get_node("ModifiedWord").chosen
	
	if modified_word == "":
		return

	emit_signal("modified", modified_word)
	visible = false
	
func _on_exitButton_pressed() -> void:
	visible = false


func _on_ModifiedWord_text_changed(new_text : String) -> void:
	_on_Titleinputbutton_pressed()


func _on_ModifiedWord_text_entered(new_text):
	_on_Titleinputbutton_pressed()
