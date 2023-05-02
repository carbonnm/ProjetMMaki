extends Panel
signal chosen_image(paths)
signal png_ko
signal too_many_selected

func _ready():
	$FileDialog.set_current_path("C://Users/")
	#$FileDialog.show()
	$FileDialog.invalidate()


func _on_FileDialog_files_selected(paths):
	if(paths.size()>1):
		emit_signal("too_many_selected")
	else:
		if not (paths[0].ends_with(".png")):
			#checks whether it's a png 
			emit_signal("png_ko")
		else:
			if get_node("../../Menuadditionimage").selected_button == 1:
				get_node("../../Menuadditionimage/ColorRect/Image1/TextureRect").texture = load_external_img(paths[0])
			if get_node("../../Menuadditionimage").selected_button == 2:
				get_node("../../Menuadditionimage/ColorRect/Image2/TextureRect").texture = load_external_img(paths[0])
			if get_node("../../Menuadditionimage").selected_button == 3:
				get_node("../../Menuadditionimage/ColorRect/Image3/TextureRect").texture = load_external_img(paths[0])
			if get_node("../../Menuadditionimage").selected_button == 4:
				get_node("../../Menuadditionimage/ColorRect/Image4/TextureRect").texture = load_external_img(paths[0])
			
			
			#get_node("Ok_menu").visible = true
			#emits the signal that will be received by the Menuadditionimagescript
			#emit_signal("chosen_image",paths)
			#visible = false
			#print(paths)
			


func load_external_img(path):
	var img = Image.new()
	img.load(ProjectSettings.globalize_path(path))
	var texture = ImageTexture.new()
	texture.create_from_image(img, Texture.FLAG_MIPMAPS)
	
	return texture
