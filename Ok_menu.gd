extends Panel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func load_external_img(path):
	var img = Image.new()
	img.load(ProjectSettings.globalize_path(path))
	var texture = ImageTexture.new()
	texture.create_from_image(img, Texture.FLAG_MIPMAPS)
	texture.set_size_override(Vector2(189, 126))
	
	return texture


func _on_Closebutton_pressed():
	visible = false


func _on_Ok_button_pressed():
	#print(get_node("../../../Menuadditionimage").selected_button)
	if get_node("../../../Menuadditionimage").selected_button == 1:
		get_node("../../../Menuadditionimage/ColorRect/Image1/TextureRect").texture = load_external_img(get_node("../../../Menuadditionimage/Pop_up").path1)
	if get_node("../../../Menuadditionimage").selected_button == 2:
		get_node("../../../Menuadditionimage/ColorRect/Image1/TextureRect").texture = load_external_img(get_node("../../../Menuadditionimage/Pop_up").path2)
	if get_node("../../../Menuadditionimage").selected_button == 3:
		get_node("../../../Menuadditionimage/ColorRect/Image1/TextureRect").texture = load_external_img(get_node("../../../Menuadditionimage/Pop_up").path3)
	if get_node("../../../Menuadditionimage").selected_button == 4:
		get_node("../../../Menuadditionimage/ColorRect/Image1/TextureRect").texture = load_external_img(get_node("../../../Menuadditionimage/Pop_up").path4)
	visible = false
