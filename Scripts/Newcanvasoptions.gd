extends Node2D

#chosen name for the new canvas
var chosen_name = ""
#default colors for the fonts are black 
var chosen_colorTitle = Color( 0, 0, 0, 1 ) 
var chosen_colorSubtitle =  Color( 0, 0, 0, 1 ) 
var chosen_colorSubsubtitle = Color( 0, 0, 0, 1 ) 

#default color for the background of the canvas is antique white
var chosen_color_background = Color( 0.980392, 0.921569, 0.843137, 1 )

#default font is Arial (the path)
var chosen_font_title = "res://Assets/Fonts/arial_narrow_7.ttf"
var chosen_font_subtitle =  "res://Assets/Fonts/arial_narrow_7.ttf"
var chosen_font_subsubtitle = "res://Assets/Fonts/arial_narrow_7.ttf"


func _ready():
	
	pass 

#--------------------------------------------------------------------------
#--------------------------------------------------------------------------
#CREATION BUTTON HANDLING and passing parameters to the NEXT SCENE
#-------------------------
func _on_BoutonCreer_button_up():
	#no need to push the button 
	chosen_name = get_node("Page/Optionmenu/Inputname").new_name
	
	#Need for a name to have been entered for the new canvas!
	if not(chosen_name ==""):
		#passing all the arguments to the next scene
		SceneSwitcher.change_scene("Main.tscn", {"namecanvas":chosen_name,
		"titlecolor":chosen_colorTitle,"subtitlecolor":chosen_colorSubtitle,"subsubtitlecolor":chosen_colorSubsubtitle,
		"backgroundcolor":chosen_color_background,
		"titlefont":chosen_font_title,
		"subtitlefont":chosen_font_subtitle,
		"subsubtitlefont":chosen_font_subsubtitle})
		
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
#Handling color-pickers (fonts and canvas'background)
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


#--------------------------------------------------------------------------
#--------------------------------------------------------------------------
#Font selection from dropdown menu (Title, subtitle, sub-subtitle)
#-------------------------
#changes the chosen font for the title 
func _on_DropdownTitle_item_selected(index):
	if index ==0:
		chosen_font_title = "res://Assets/Fonts/Perfect DOS VGA 437 Win.ttf"
	if index ==1:
		chosen_font_title = "res://Assets/Fonts/Minecraft.ttf"
	if index ==2:
		chosen_font_title = "res://Assets/Fonts/arial_narrow_7.ttf"
	if index ==3:
		chosen_font_title = "res://Assets/Fonts/Gabrielle.ttf"


#changes the chosen font for the subtitle 
func _on_Dropdownsubtitle_item_selected(index):
	if index ==0:
		chosen_font_subtitle = "res://Assets/Fonts/Perfect DOS VGA 437 Win.ttf"
	if index ==1:
		chosen_font_subtitle = "res://Assets/Fonts/Minecraft.ttf"
	if index ==2:
		chosen_font_subtitle = "res://Assets/Fonts/arial_narrow_7.ttf"
	if index ==3:
		chosen_font_subtitle = "res://Assets/Fonts/Gabrielle.ttf"

#changes the chosen font for the sub-subtitle 
func _on_DropdownSubsub_item_selected(index):
	if index ==0:
		chosen_font_subsubtitle = "res://Assets/Fonts/Perfect DOS VGA 437 Win.ttf"
	if index ==1:
		chosen_font_subsubtitle = "res://Assets/Fonts/Minecraft.ttf"
	if index ==2:
		chosen_font_subsubtitle = "res://Assets/Fonts/arial_narrow_7.ttf"
	if index ==3:
		chosen_font_subsubtitle = "res://Assets/Fonts/Gabrielle.ttf"

#No need to press Enter anymore
func _on_Titleinputbutton_pressed():
	chosen_name = get_node("Page/Optionmenu/Inputname").new_name
	





func _on_Inputname_text_entered(new_text: String) -> void:
	_on_BoutonCreer_button_up()
