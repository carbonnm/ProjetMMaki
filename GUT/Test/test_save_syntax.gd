extends "res://addons/gut/test.gd"

func before_each():
	SaveLogic.SAVE_FILE = "user://gut_my_save_file.save"

func after_each():
	SaveLogic.SAVE_FILE = "user://my_save_file.save"

func after_all():
	var dir = Directory.new()
	dir.remove("user://gut_my_save_file.save")

func test_create_save_data():
	# Arrange
	var user_data = {"TestTheme": [["res://Assets/Fonts/Minecraft.ttf",Color(0.16, 0.29, 0.61, 1)],
						["res://Assets/Fonts/PeaberryBase.ttf",Color(0.93, 0.53, 0.58,1)],
						["res://Assets/Fonts/Perfect DOS VGA 437 Win.ttf",Color(1, 0.8, 0.2, 1 )],
						[Color( 0.980392, 0.921569, 0.843137, 1 )]]}
	# Act
	SaveLogic.user_data = user_data
	SaveLogic.save_data()
	SaveLogic.load_data()
	var result = SaveLogic.user_data
	# Assert
	assert_eq_deep(result, user_data)
