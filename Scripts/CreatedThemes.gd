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
	print("pressed!",themename)
	
