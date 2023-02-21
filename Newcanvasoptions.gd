extends Node2D

func _ready():
	
	pass 

#--------------------------------------------------------------------------
#--------------------------------------------------------------------------
#CREATION BUTTON HANDLING and passing parameters to the NEXT SCENE
#-------------------------
func _on_BoutonCreer_button_up():
	var name_canvas = get_node("Page/Optionmenu/Inputname").new_name
	#Need for a name to have been entered for the new canvas!
	if not(name_canvas ==""):
		SceneSwitcher.change_scene("Main.tscn", {"namecanvas":name_canvas})
	else:
		print("Besoin d'un titre pour le nouveau canvas, Faudra afficher un ptit message ~")
	
#--------------------------------------------------------------------------
#--------------------------------------------------------------------------
#AESTHETIC (little arrow animation on creation button hovering)
#-------------------------

#launches little arrow animation on mouse entered
func _on_BoutonCreer_mouse_entered():
	
	get_child(0).get_child(0).get_child(0).get_child(1).playing = true

#stops little arrow animation on mouse entered
func _on_BoutonCreer_mouse_exited():
	get_child(0).get_child(0).get_child(0).get_child(1).playing = false

#--------------------------------------------------------------------------
#--------------------------------------------------------------------------
#Handling color-pickers
#-------------------------

#New color has been selected for the Title and changes button to that color
func _on_ColorPickerButtonTitle_color_changed(new_color):
	var cp_title = get_node("Page/Colorfontsmenu/ColorPickerButtonTitle")
	cp_title.get_stylebox("normal").bg_color = new_color
	
#New color has been selected for the Sub-title and changes button to that color
func _on_ColorPickerButtonSubtitle_color_changed(new_color):
	var cp_subtitle = get_node("Page/Colorfontsmenu/ColorPickerButtonSubtitle")
	cp_subtitle.get_stylebox("normal").bg_color = new_color
	

#New color has been selected for the Sub-title and changes button to that color
func _on_ColorPickerButtonSubsubtitle_color_changed(new_color):
	var cp_subsubtitle = get_node("Page/Colorfontsmenu/ColorPickerButtonSubsubtitle")
	cp_subsubtitle.get_stylebox("normal").bg_color = new_color
	
