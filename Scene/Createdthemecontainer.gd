extends Panel

signal selected_theme(themename)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_SelectButton_pressed():
	var themename = get_child(1).bbcode_text
	
	emit_signal("selected_theme",themename)
	
	


func _on_SelectButton_mouse_entered():
	var themename 
	get_child(1).bbcode_text = "[shake]"+themename+"[/shake]"
	



func _on_SelectButton_mouse_exited():
	get_child(1).bbcode_text = "."
