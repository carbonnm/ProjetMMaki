extends LineEdit

var chosen : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_ModifiedWord_text_changed(new_text):
	chosen = new_text
