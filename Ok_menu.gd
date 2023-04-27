extends Panel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Closebutton_pressed():
	visible = false


func _on_Ok_button_pressed():
	var texture = load("res://Assets/temporary_dir/duckeyeclosemouthclose.png")
	var image = texture.get_data()
	image.resize(189, 126)
	var text = ImageTexture.new()
	text.create_from_image(image)
	get_node("../../Menuadditionimage/ColorRect/Image1").set_button_icon(text)
	visible = false
