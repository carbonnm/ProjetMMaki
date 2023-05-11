extends Node2D

#chosen name for the new canvas
onready var chosen_name = ""
#default colors for the fonts are black 
onready var chosen_color_title = Color( 0, 0, 0, 1 ) 
onready var chosen_color_subtitle =  Color( 0, 0, 0, 1 ) 
onready var chosen_color_subsubtitle = Color( 0, 0, 0, 1 ) 

#default color for the background of the canvas is antique white
onready var chosen_color_background = Color( 0.980392, 0.921569, 0.843137, 1 )

#default font is Arial (the path)
onready var chosen_font_title = "res://Assets/Fonts/arial_narrow_7.ttf"
onready var chosen_font_subtitle =  "res://Assets/Fonts/arial_narrow_7.ttf"
onready var chosen_font_subsubtitle = "res://Assets/Fonts/arial_narrow_7.ttf"

onready var dic_random_title ={
	0: "La boule magique",
	1: "Power-up-Points",
	2: "Cassoulet des Pirates",
	3:"Ceci n'est pas une Jojo réf",
	4: "Exposé des avantages et inconvénients des patates",
	5: "Enterrement de Dédé",
	6: "Dernière dent de lait de José", 
	7: "Pato de plastico", 
	8: "Penser à reprendre du liquide vaisselle",
	9:"According to all known laws of aviation",
	10:"Layers of Ogres and Onions ",
	11:"It's bigger on the inside",
	12:"Chapi chapo patpapo chapo chapi patapi",
	13:"La vérité est ailleurs",
	14:"Let's get this freakshow on the road.",
	15:"When I was a young boy ...",
	16:"Getting a weird impression of deja-vu",
	17:"Les dynamiques quantiques de Porygon-Z",
	18:"Test: à quel Winx ressembles-tu le plus?",
	19:"Recette d'implémentation du pattern State",
	20: "https://youtu.be/dQw4w9WgXcQ",
	21:"And you may find yourself ...",
	22:"P'tite rando dans le supermaché Coco",
	23:"The manatee of Melancholy hill",
	24:"Aider Marie dans la mairie",
	25:"There was a hole there, it's gone now",
	26:"Lenny? LLLLLEEENNNNy! , ELNY?",
	27: "Oof",
	28:"Eulogy for Kenny Mccormick at 9pm",
	29:"Kyrat's special crab rangoon recipe",
	30:"42 raisons de se mettre à Rodin",
	31:"Petit curieux, il n'y a rien à trouver ici",
	32:"Visite de routine chez le Dr Maison",
	33:"Visit of a condo in Wisteria Lane",
	34:"Savez-vous VRAIMENT planter les choux?",
	35:"Reprendre des croquettes pour Schrodinger",
	36: "Cours de cuisine chez le Dr Lecter",
	37:"Kamoulox!",
	38:"C'est pas faux.",
	39:"Mon petit cette paix est ce pour quoi luttent...",
	40:"Squalalah, nous sommes partis",
	41:"Saucisse",
	42: "Ammener le Blackbird au contôle technique",
	43:"Speedrun any % - syllabus de compléxité ",
	44:"Doom walkthrough by VincentduI30",
	45:"It's MMAKI not Maki",
	46:"Roullette russe, choix des options de master 2",
	47:"Sugar.Honey.Ice.Tea",
	48:"Friend.Not.Atrocious.Freaks",
	49:"Geocaching: trouver la motivation",
	50:"Planter les piments à côté du basilic",
	51:"Écouter de l'A.S.M.R. ou du Heavy metal?"
}
onready var already_seen = []
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
		SceneSwitcher.change_scene("Scene/Canvas.tscn", {"canvasname": chosen_name,
		"titlecolor":chosen_color_title,"subtitlecolor":chosen_color_subtitle,"subsubtitlecolor":chosen_color_subsubtitle,
		"backgroundcolor":chosen_color_background,
		"titlefont":chosen_font_title,
		"subtitlefont":chosen_font_subtitle,
		"subsubtitlefont":chosen_font_subsubtitle})
		
	#No name entered => Displaying message asking to enter one
	else:
		get_node("Page/Optionmenu/Namenotentered").visible = true
	


func _on_ButtonSave_button_up():
	get_node("Page/Themesave").visible = true
	

	

func _on_ButtonChoice_button_up():
	get_node("Page/Themechoice").visible = true
	



#--------------------------------------------------------------------------
#--------------------------------------------------------------------------
#AESTHETIC (little arrow animation on creation button hovering)
#-------------------------

#launches little arrow animation on mouse entered
func _on_BoutonCreer_mouse_entered():
	
	get_node("Page/ContainerBoutonCreer/Littlearrow").playing = true

#stops little arrow animation on mouse entered
func _on_BoutonCreer_mouse_exited():
	get_node("Page/ContainerBoutonCreer/Littlearrow").playing = false
	


func _on_ButtonSave_mouse_entered():
	get_node("Page/ContainerBoutonSave/Saveicon").playing = true


#stops little save icon  animation on mouse entered
func _on_ButtonSave_mouse_exited():
	get_node("Page/ContainerBoutonSave/Saveicon").playing = false

func _on_ButtonChoice_mouse_entered():
	get_node("Page/ContainerBoutonChoice/Choiceicon").playing = true

#stops little save icon  animation on mouse entered
func _on_ButtonChoice_mouse_exited():
	get_node("Page/ContainerBoutonChoice/Choiceicon").playing = false
	
#--------------------------------------------------------------------------
#--------------------------------------------------------------------------
#Handling color-pickers (fonts and canvas'background)
#-------------------------

#New color has been selected for the Title 
func _on_ColorPickerButtonTitle_color_changed(new_color):
	var cp_title = get_node("Page/Colorfontsmenu/ColorPickerButtonTitle")
	#changes button to that color
	cp_title.get_stylebox("normal").bg_color = new_color
	chosen_color_title =  new_color
	
#New color has been selected for the Sub-title
func _on_ColorPickerButtonSubtitle_color_changed(new_color):
	var cp_subtitle = get_node("Page/Colorfontsmenu/ColorPickerButtonSubtitle")
	#changes button to that color
	cp_subtitle.get_stylebox("normal").bg_color = new_color
	chosen_color_subtitle =  new_color

#New color has been selected for the Sub-title
func _on_ColorPickerButtonSubsubtitle_color_changed(new_color):
	var cp_subsubtitle = get_node("Page/Colorfontsmenu/ColorPickerButtonSubsubtitle")
	#changes button to that color
	cp_subsubtitle.get_stylebox("normal").bg_color = new_color
	chosen_color_subsubtitle =  new_color

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
	



func _on_Randombutton_button_up():
	var anim_node = get_node("Page/Randomtitlebutton/Diceicon")
	anim_node.playing = true
	yield(get_tree().create_timer(1.5), "timeout")
	anim_node.playing= false
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var number_random = rng.randi_range(0, dic_random_title.size()-1)
	if not(number_random in already_seen):
		already_seen.append(number_random)
		get_node("Page/Optionmenu/Inputname").text = dic_random_title[number_random]
		get_node("Page/Optionmenu/Inputname").new_name = dic_random_title[number_random] 
	else: 
		#second chance before having to push on the dice icon again
		number_random = rng.randi_range(0, dic_random_title.size()-1)
		if not(number_random in already_seen):
			already_seen.append(number_random)
			get_node("Page/Optionmenu/Inputname").text = dic_random_title[number_random]
			get_node("Page/Optionmenu/Inputname").new_name = dic_random_title[number_random] 
