extends Control

onready var canvas = $"../"
onready var image1 = $"../ChoixImage/Image1/TextureRect"
onready var image2 = $"../ChoixImage/Image2/TextureRect"
onready var image3 = $"../ChoixImage/Image3/TextureRect"
onready var image4 = $"../ChoixImage/Image4/TextureRect"

var modified_word : String = ""
signal modified(modified_word)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Titleinputbutton_pressed():
	modified_word = get_node("ModifiedWord").chosen
	print(modified_word)
	
	if modified_word == "":
		return

	emit_signal("modified", modified_word)
	visible = false
	get_node("ModifiedWord/Titleinputbutton/ArrowIcon").playing = false
	get_node("Closebutton/Crossicon").playing = false
	
	var path1 = str("res://4ImagesChoix/"+modified_word+"/"+modified_word+"1.png")
	var path2 = str("res://4ImagesChoix/"+modified_word+"/"+modified_word+"2.png")
	var path3 = str("res://4ImagesChoix/"+modified_word+"/"+modified_word+"3.png")
	var path4 = str("res://4ImagesChoix/"+modified_word+"/"+modified_word+"4.png")

	
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


func _on_ModifiedWord_text_changed(_new_text : String) -> void:
	_on_Titleinputbutton_pressed()


func _on_ModifiedWord_text_entered(_new_text):
	_on_Titleinputbutton_pressed()


func _on_Closebutton_pressed():
	visible = false
	get_node("Closebutton/Crossicon").playing = false

func _on_Closebutton_mouse_entered():
	get_node("Closebutton/Crossicon").playing = true


func _on_Closebutton_mouse_exited():
	get_node("Closebutton/Crossicon").playing = false


func _on_Titleinputbutton_mouse_entered():
	get_node("ModifiedWord/Titleinputbutton/ArrowIcon").playing = true


func _on_Titleinputbutton_mouse_exited():
	get_node("ModifiedWord/Titleinputbutton/ArrowIcon").playing = false
