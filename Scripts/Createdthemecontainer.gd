extends Panel

signal selected_theme(themename)
var notassignedyet = true
var themename=""
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_SelectButton_pressed():
	
	
	emit_signal("selected_theme",themename)
	


func _on_Okbutton_pressed():
	emit_signal("selected_theme",themename)




func _on_SelectButton_mouse_entered():
	
	if notassignedyet and get_child(1).bbcode_text != "PLACEHOLDER":
		themename = get_child(1).bbcode_text
		notassignedyet = false
		
	get_child(1).bbcode_text = "[shake]"+themename+"[/shake]"
	



func _on_SelectButton_mouse_exited():
	get_child(1).bbcode_text = themename


