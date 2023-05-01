extends Panel

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_node("../../../Menuadditionimage").selected_button == 1:
		var texture = load("res://Assets/temporary_dir/temp1.png")
		var image = texture.get_data()
		image.resize(189, 126)
		var text = ImageTexture.new()
		text.create_from_image(image)
		get_node("Image_placeholder").set_button_icon(text)
	if get_node("../../../Menuadditionimage").selected_button == 2:
		var texture = load("res://Assets/temporary_dir/temp2.png")
		var image = texture.get_data()
		image.resize(189, 126)
		var text = ImageTexture.new()
		text.create_from_image(image)
		get_node("Image_placeholder").set_button_icon(text)
	if get_node("../../../Menuadditionimage").selected_button == 3:
		var texture = load("res://Assets/temporary_dir/temp3.png")
		var image = texture.get_data()
		image.resize(189, 126)
		var text = ImageTexture.new()
		text.create_from_image(image)
		get_node("Image_placeholder").set_button_icon(text)
	if get_node("../../../Menuadditionimage").selected_button == 4:
		var texture = load("res://Assets/temporary_dir/temp4.png")
		var image = texture.get_data()
		image.resize(189, 126)
		var text = ImageTexture.new()
		text.create_from_image(image)
		get_node("Image_placeholder").set_button_icon(text)



func _on_Closebutton_pressed():
	visible = false


func _on_Ok_button_pressed():
	#print(get_node("../../../Menuadditionimage").selected_button)
	if get_node("../../../Menuadditionimage").selected_button == 1:
		var texture = load("res://Assets/temporary_dir/temp1.png")
		var image = texture.get_data()
		image.resize(189, 126)
		var text = ImageTexture.new()
		text.create_from_image(image)
		get_node("../../../Menuadditionimage/ColorRect/Image1").set_button_icon(text)
	if get_node("../../../Menuadditionimage").selected_button == 2:
		var texture = load("res://Assets/temporary_dir/temp2.png")
		var image = texture.get_data()
		image.resize(189, 126)
		var text = ImageTexture.new()
		text.create_from_image(image)
		get_node("../../../Menuadditionimage/ColorRect/Image2").set_button_icon(text)
	if get_node("../../../Menuadditionimage").selected_button == 3:
		var texture = load("res://Assets/temporary_dir/temp3.png")
		var image = texture.get_data()
		image.resize(189, 126)
		var text = ImageTexture.new()
		text.create_from_image(image)
		get_node("../../../Menuadditionimage/ColorRect/Image3").set_button_icon(text)
	if get_node("../../../Menuadditionimage").selected_button == 4:
		var texture = load("res://Assets/temporary_dir/temp4.png")
		var image = texture.get_data()
		image.resize(189, 126)
		var text = ImageTexture.new()
		text.create_from_image(image)
		get_node("../../../Menuadditionimage/ColorRect/Image4").set_button_icon(text)
	visible = false
