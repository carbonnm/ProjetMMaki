extends Node

#path to the file where the save file is located
const SAVE_FILE = "user://my_save_file.save"
#dictionnary containing the created themes and other informations worth saving 
#to define together
var user_data ={}


func _ready():
	load_data()

# updates the saved data 
# (creates the file if it's not done yet and fills it with default information to be saved)
func save_data():
	var file = File.new()
	file.open(SAVE_FILE,File.WRITE)
	file.store_var(user_data)
	file.close()

#constructor for the save file (only called once !)
func load_data():
	var file = File.new()
	#equivalent to check if instance is null in singleton pattern 
	if not(file.file_exists(SAVE_FILE)):
		user_data = {
			"UnamurThemeBOLD": [["res://Assets/Fonts/ITC Avant Garde Gothic Bold.otf",Color(40, 73, 156, 1) ],
								["res://Assets/Fonts/ITC Avant Garde Gothic Bold.otf",Color(238, 135, 148,1) ],
								["res://Assets/Fonts/ITC Avant Garde Gothic Bold.otf",Color(255, 204, 51, 1 ) ],[Color( 0.980392, 0.921569, 0.843137, 1 )]],
			"UnamurThemeLIGHT": [["res://Assets/Fonts/ITC Avant Garde Gothic LT Book Regular.otf",Color(107, 84, 163, 1) ],
								["res://Assets/Fonts/ITC Avant Garde Gothic LT Book Regular.otf",Color( 50, 145, 207,1) ],
								["res://Assets/Fonts/ITC Avant Garde Gothic LT Book Regular.otf",Color( 238, 135, 148) ],
								[Color( 0.980392, 0.921569, 0.843137, 1 )]],
								
			"TestTheme":[["res://Assets/Fonts/Minecraft.ttf",Color(40, 73, 156, 1)],
						["res://Assets/Fonts/PeaberryBase.ttf",Color(238, 135, 148,1)],
						["res://Assets/Fonts/Perfect DOS VGA 437 Win.ttf",Color(255, 204, 51, 1 )],
						[Color( 0.980392, 0.921569, 0.843137, 1 )]]
			
								
		}
		save_data()
	file.open(SAVE_FILE,File.READ)
	user_data = file.get_var()
	file.close()
	
	
	
