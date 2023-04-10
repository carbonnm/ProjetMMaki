extends Panel

onready var save_file = SaveLogic.user_data
onready var fullpicture = get_owner()
onready var themecontainer = preload("res://Scene/Createdthemecontainer.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	themebuilding()
	

func themebuilding():
	#displays all of the user's created themes
	for theme in save_file.keys():
		if not (theme == "UnamurThemeBOLD" or theme == "UnamurThemeLIGHT"):
			
			#for themes that aren't UNamur's defaults (one that were created by the user)
			var createdtheme = themecontainer.instance()
	
			createdtheme.get_child(1).bbcode_text = theme
			#signal magic 
			createdtheme.connect("selected_theme", self, "_on_selected")
			#adding the new child to the panel
			
			add_child(createdtheme)
			
			
func _on_selected(themename):
	#setting up the theme (fonts,color,... for the new canvas )
	print("pressed!",themename)
	fullpicture.chosen_font_title = save_file.get(themename)[0][0]
	fullpicture.chosen_color_title = save_file.get(themename)[0][1]
	fullpicture.chosen_font_subtitle= save_file.get(themename)[1][0]
	fullpicture.chosen_color_subtitle= save_file.get(themename)[1][1]
	fullpicture.chosen_font_subsubtitle = save_file.get(themename)[2][0]
	fullpicture.chosen_color_subsubtitle = save_file.get(themename)[2][1]
	fullpicture.chosen_color_background = save_file.get(themename)[3][0]
