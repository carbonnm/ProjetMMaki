extends Panel
signal chosen_image(paths)
signal png_ko
signal too_many_selected

func _ready():
	$FileDialog.set_current_path("C://Users/")
	$FileDialog.show()
	$FileDialog.invalidate()


func _on_FileDialog_files_selected(paths):
	if(paths.size()>1):
		emit_signal("too_many_selected")
	else:
		if not (paths[0].ends_with(".png")):
			#checks whether it's a png 
			emit_signal("png_ko")
		else:
			
			var dir = Directory.new()
			dir.open("res://Assets")
			
			var image_file = File.new()
			image_file.open(paths[0], File.READ)
			image_file.close()
			
			
			dir.copy(paths[0], "res://Assets/temporary_dir/duckeyeclosemouthclose.png")
			print(image_file)
			
			
			get_node("Ok_menu").visible = true
			#emits the signal that will be received by the Menuadditionimagescript
			#emit_signal("chosen_image",paths)
			#visible = false
			#print(paths)
			

