extends Panel
signal chosen_image(paths)

func _ready():
	$FileDialog.set_current_path("C://Users/")
	#$FileDialog.show()
	$FileDialog.invalidate()


func _on_FileDialog_file_selected(path):
	var image = load(path)


func _on_FileDialog_files_selected(paths):
	#emits the signal that will be received by the Menuadditionimagescript
	emit_signal("chosen_image",paths)
	visible = false
