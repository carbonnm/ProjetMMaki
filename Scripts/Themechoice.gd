extends Panel

#retrieves the save file singleton
onready var save_file = SaveLogic.user_data
onready var fullpicture = get_owner()

# Called when the node enters the scene tree for the first time.
func _ready():
	print(save_file) # Replace with function body.


func _on_BoutonUNamur_pressed():
	
	print("test")
	#Assigning the different fonts and color fonts to the selected theme
	fullpicture.chosen_font_title = save_file.get("UnamurThemeLIGHT")[0][0]
	fullpicture.chosen_color_title = save_file.get("UnamurThemeLIGHT")[0][1]
	fullpicture.chosen_font_subtitle= save_file.get("UnamurThemeLIGHT")[1][0]
	fullpicture.chosen_color_subtitle= save_file.get("UnamurThemeLIGHT")[1][1]
	fullpicture.chosen_font_subsubtitle = save_file.get("UnamurThemeLIGHT")[2][0]
	fullpicture.chosen_color_subsubtitle = save_file.get("UnamurThemeLIGHT")[2][1]
	
	
	
	


func _on_BoutonUNamur_mouse_entered():
	$UNamur_theme.bbcode_text = "[shake]Thème UNamur [/shake]"


func _on_BoutonUNamur_mouse_exited():
	$UNamur_theme.bbcode_text = "Thème UNamur "


func _on_Closebutton_button_up():
	get_node("Closebutton/Crossicon").playing = false
	visible = false


func _on_Closebutton_mouse_entered():
	get_node("Closebutton/Crossicon").playing = true


func _on_Closebutton_mouse_exited():
	get_node("Closebutton/Crossicon").playing = false
