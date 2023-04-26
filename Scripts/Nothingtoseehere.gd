extends HBoxContainer



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Pressme_button_up():
	get_node("Notaneasteregg/Scream").play()
	yield(get_tree().create_timer(1), "timeout")
	get_node("Notaneasteregg/Scream").stop()
