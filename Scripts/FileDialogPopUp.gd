extends Panel
signal chosen_image(paths)
signal png_ko
signal too_many_selected

export (String) var path1
export (String) var path2
export (String) var path3
export (String) var path4

func _ready():
	var name : String = OS.get_environment("USERNAME")
	#print(name)
	$FileDialog.set_current_path("C://Users/"+ name + "/Downloads/")
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
				path1 = paths[0]
				get_node("Ok_menu/Image_placeholder").texture = load_external_img(path1)
			if get_node("../../Menuadditionimage").selected_button == 2:
				path2 = paths[0]
				get_node("Ok_menu/Image_placeholder").texture = load_external_img(path2)
			if get_node("../../Menuadditionimage").selected_button == 3:
				path3 = paths[0]
				get_node("Ok_menu/Image_placeholder").texture = load_external_img(path3)
			if get_node("../../Menuadditionimage").selected_button == 4:
				path4 = paths[0]
				get_node("Ok_menu/Image_placeholder").texture = load_external_img(path4)
			
			
			get_node("Ok_menu").visible = true
			#emits the signal that will be received by the Menuadditionimagescript
			#emit_signal("chosen_image",paths)
			#visible = false
			#print(paths)
			


func load_external_img(path):
	var img = Image.new()
	img.load(ProjectSettings.globalize_path(path))
	var texture = ImageTexture.new()
	texture.create_from_image(img, Texture.FLAG_MIPMAPS)
	texture.set_size_override(Vector2(1024, 1024))
	
	return texture
