extends Control

onready var canvas = $"../"
onready var image1 = $"../ChoixImage/Image1"
onready var image2 = $"../ChoixImage/Image2"
onready var image3 = $"../ChoixImage/Image3"
onready var image4 = $"../ChoixImage/Image4"

func _on_exitButton_pressed():
	visible = false


func _on_okButton_pressed():
	visible = false
	var word = str(canvas.word_recognized)
	var size_word : int = len(word) - 4
	var path1 = str("res://4ImagesChoix/"+word.left(size_word)+"/"+word.left(size_word)+"1.png")
	var path2 = str("res://4ImagesChoix/"+word.left(size_word)+"/"+word.left(size_word)+"2.png")
	var path3 = str("res://4ImagesChoix/"+word.left(size_word)+"/"+word.left(size_word)+"3.png")
	var path4 = str("res://4ImagesChoix/"+word.left(size_word)+"/"+word.left(size_word)+"4.png")

	var texture1 = load(path1)
	var texture2 = load(path2)
	var texture3 = load(path3)
	var texture4 = load(path4)
	image1.set_button_icon(texture1)
	image2.set_button_icon(texture2)
	image3.set_button_icon(texture3)
	image4.set_button_icon(texture4)
	
	
	var size_pop_up : Vector2 = get_node("../ChoixImage/ColorRect").get_global_rect().size
	get_node("../ChoixImage").rect_position = get_node("../Camera").get_camera_position() - size_pop_up - Vector2(120, -200)
	get_node("../ChoixImage").visible = true


func _on_modifyButton_pressed():
	visible = false
	var size_pop_up : Vector2 = get_node("../ModificationWord/ColorRect").get_global_rect().size
	get_node("../ModificationWord").rect_position = get_node("../Camera").get_camera_position() - size_pop_up + Vector2(200, 100)
	get_node("../ModificationWord").visible = true
