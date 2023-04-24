extends Panel

func _ready():
	$FileDialog.set_current_path("C://Users/")
	$FileDialog.show()
	$FileDialog.invalidate()




func _on_FileDialog_files_selected(paths):
	pass # Replace with function body.
