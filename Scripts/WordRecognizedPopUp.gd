extends Control

onready var canvas = $"../"
onready var image1 = $"../ChoixImage/Image1/TextureRect"
onready var image2 = $"../ChoixImage/Image2/TextureRect"
onready var image3 = $"../ChoixImage/Image3/TextureRect"
onready var image4 = $"../ChoixImage/Image4/TextureRect"

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

	
	image1.texture = load_external_img(path1)
	image2.texture = load_external_img(path2)
	image3.texture = load_external_img(path3)
	image4.texture = load_external_img(path4)
	
	
	var size_pop_up : Vector2 = get_node("../ChoixImage/ColorRect").get_global_rect().size
	get_node("../ChoixImage").rect_position = get_node("../Camera").get_camera_position() - size_pop_up - Vector2(120, -200)
	get_node("../ChoixImage").visible = true
	
	canvas.word_recognized = ""
	
func load_external_img(path):
	var img = Image.new()
	img.load(ProjectSettings.globalize_path(path))
	var texture = ImageTexture.new()
	texture.create_from_image(img, Texture.FLAG_MIPMAPS)
	texture.set_size_override(Vector2(180, 180))
	
	return texture


func _on_modifyButton_pressed():
	visible = false
	var size_pop_up : Vector2 = get_node("../ModificationWord/ColorRect").get_global_rect().size
	get_node("../ModificationWord").rect_position = get_node("../Camera").get_camera_position() - size_pop_up + Vector2(200, 100)
	get_node("../ModificationWord").visible = true
