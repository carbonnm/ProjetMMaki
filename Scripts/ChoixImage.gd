extends Control

onready var image1 = $Image1
onready var image2 = $Image2
onready var image3 = $Image3
onready var image4 = $Image4

onready var canvas = $"../"
onready var transform = $"../StateManager/SignalSwitcher/Transform"


onready var one_pressed = false
onready var current_pressed
var chosen_button_icon

func _on_OKButton_pressed():
	if not chosen_button_icon :
		visible = false
		get_node("../InvalidChoice").rect_position = canvas.drawing_position
		get_node("../InvalidChoice").visible = true
	
	var area = Area2D.new()
	var c_shape = CollisionShape2D.new()
	var r_shape = RectangleShape2D.new()
	var drawing = Sprite.new()
	drawing.texture = chosen_button_icon
	
	var center : Vector2 = canvas.drawing_position + Vector2(drawing.texture.get_width()/2, drawing.texture.get_height()/2)
	r_shape.extents = Vector2((drawing.texture.get_width())/2, (drawing.texture.get_height())/2)
	c_shape.shape = r_shape
	area.position = center
	area.add_child(c_shape)
	area.add_child(drawing)
	get_node("../Elements").add_child(area)
	visible = false


func _on_Image1_pressed():
	
	if one_pressed:
		get_node(current_pressed).modulate = Color(1.00,1.00,1.00,1)
	one_pressed = true
	chosen_button_icon = image1.icon
	get_node("Image1").modulate = Color(0.57,0.52,0.52,1)
	current_pressed = "Image1"

func _on_Image2_pressed():
	if one_pressed:
		get_node(current_pressed).modulate = Color(1.00,1.00,1.00,1)
	one_pressed = true
	chosen_button_icon = image2.icon
	get_node("Image2").modulate = Color(0.57,0.52,0.52,1)
	current_pressed = "Image2"


func _on_Image3_pressed():
	if one_pressed:
		get_node(current_pressed).modulate = Color(1.00,1.00,1.00,1)
	one_pressed = true
	chosen_button_icon = image3.icon
	get_node("Image3").modulate = Color(0.57,0.52,0.52,1)
	current_pressed = "Image3"

func _on_Image4_pressed():
	if one_pressed:
		get_node(current_pressed).modulate = Color(1.00,1.00,1.00,1)
	one_pressed = true
	chosen_button_icon = image4.icon
	get_node("Image4").modulate = Color(0.57,0.52,0.52,1)
	current_pressed = "Image4"
	



func _on_OKButton_mouse_entered():
	get_node("OKButton/DancingOk").bbcode_text = "[wave amp=30]Ok [/wave]"

func _on_OKButton_mouse_exited():
	get_node("OKButton/DancingOk").bbcode_text = "Ok"
