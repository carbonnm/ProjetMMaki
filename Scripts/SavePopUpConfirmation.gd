extends Control

var validation: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_exitButton_pressed():
	visible = false


func _on_cancelButton_pressed():
	visible = false


func _on_okButton_pressed():
	validation = true
	visible = false
