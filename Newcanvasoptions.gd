extends Node2D

#default colors for the fonts are black 
var chosen_colorTitle = Color( 0, 0, 0, 1 ) 
var chosen_colorSubtitle =  Color( 0, 0, 0, 1 ) 
var chosen_colorSubsubtitle = Color( 0, 0, 0, 1 ) 

#default color for the background of the canvas is antique white
var chosen_color_background = Color( 0.980392, 0.921569, 0.843137, 1 )

#default font is Arial


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
		#passing all the arguments to the next scene
		SceneSwitcher.change_scene("Main.tscn", {"namecanvas":name_canvas,
		"titlecolor":chosen_colorTitle,"subtitlecolor":chosen_colorSubtitle,"subsubtitlecolor":chosen_colorSubsubtitle,
		"backgroundcolor":chosen_color_background})
		
	#No name entered => Displaying message asking to enter one
	else:
		get_node("Page/Optionmenu/Namenotentered").visible = true
		
#--------------------------------------------------------------------------
#--------------------------------------------------------------------------
#AESTHETIC (little arrow animation on creation button hovering)
#-------------------------

#launches little arrow animation on mouse entered
func _on_BoutonCreer_mouse_entered():
	
	get_node("Page/Optionmenu/ContainerBoutonCreer/Littlearrow").playing = true

#stops little arrow animation on mouse entered
func _on_BoutonCreer_mouse_exited():
	get_node("Page/Optionmenu/ContainerBoutonCreer/Littlearrow").playing = false

#--------------------------------------------------------------------------
#--------------------------------------------------------------------------
#Handling color-pickers
#-------------------------

#New color has been selected for the Title 

func _on_ColorPickerButtonTitle_color_changed(new_color):
	var cp_title = get_node("Page/Colorfontsmenu/ColorPickerButtonTitle")
	#changes button to that color
	cp_title.get_stylebox("normal").bg_color = new_color
	chosen_colorTitle =  new_color
	
#New color has been selected for the Sub-title
func _on_ColorPickerButtonSubtitle_color_changed(new_color):
	var cp_subtitle = get_node("Page/Colorfontsmenu/ColorPickerButtonSubtitle")
	#changes button to that color
	cp_subtitle.get_stylebox("normal").bg_color = new_color
	chosen_colorSubtitle =  new_color

#New color has been selected for the Sub-title
func _on_ColorPickerButtonSubsubtitle_color_changed(new_color):
	var cp_subsubtitle = get_node("Page/Colorfontsmenu/ColorPickerButtonSubsubtitle")
	#changes button to that color
	cp_subsubtitle.get_stylebox("normal").bg_color = new_color
	chosen_colorSubsubtitle =  new_color

#New color has been selected for the canvas background
func _on_ColorPickerButtonCanvas_color_changed(new_color):
	var cp_subsubtitle = get_node("Page/Canvascolormenu/ColorPickerButtonCanvas")
	#changes button to that color
	cp_subsubtitle.get_stylebox("normal").bg_color = new_color
	chosen_color_background =  new_color
