extends Panel


onready var fullpicture = get_owner()
onready var user_data = SaveLogic.user_data

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Closebutton_button_up():
	get_node("Closebutton/Crossicon").playing = false
	visible = false


func _on_Okbutton_button_up():
	
	var name_entered = $Themenameinput.new_theme_name 
	
	if(name_entered ==""):
		$Themenamenotentered.visible = true
	else:
		visible = false
		$Themenamenotentered.visible = false
		
		#adds the new theme to the user's saved ones
		if not(user_data.has(name_entered)):
			user_data[name_entered] = [[fullpicture.chosen_name,fullpicture.chosen_color_title],
										[fullpicture.chosen_font_title,fullpicture.chosen_color_subtitle],
										[fullpicture.chosen_font_subsubtitle,fullpicture.chosen_color_subsubtitle]]
		$Themenameinput.text = ""
		print(user_data)

func _on_Closebutton_mouse_entered():
	get_node("Closebutton/Crossicon").playing = true




func _on_Closebutton_mouse_exited():
	get_node("Closebutton/Crossicon").playing = false




func _on_Okbutton_mouse_entered():
	get_node("Okbutton/Checkmarkicon").playing = true

func _on_Okbutton_mouse_exited():
	get_node("Okbutton/Checkmarkicon").playing = false
