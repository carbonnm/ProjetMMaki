extends Control

onready var image1 = $Image1
onready var image2 = $Image2
onready var image3 = $Image3
onready var image4 = $Image4

var chosen_button_icon


func _on_OKButton_pressed():
	var drawing = Sprite.new()
	drawing.texture = chosen_button_icon
	drawing.position = Vector2(500, 300)
	get_node("../Elements").add_child(drawing)
	visible = false


func _on_Image1_pressed():
	chosen_button_icon = image1.icon


func _on_Image2_pressed():
	chosen_button_icon = image2.icon


func _on_Image3_pressed():
	chosen_button_icon = image3.icon


func _on_Image4_pressed():
	chosen_button_icon = image4.icon
