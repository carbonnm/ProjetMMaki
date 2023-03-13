extends LineEdit

var chosen = ""

func _ready():
	pass 

#updates current text 
func _on_Inputtitle_text_changed(new_text):
	chosen = new_text

