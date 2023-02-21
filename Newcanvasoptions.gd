extends Node2D




# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

#To the new canvas 
func _on_BoutonCreer_button_up():
	get_tree().change_scene("res://Main.tscn")

	
#AESTHETIC (launches little arrow animation on mouse entered)
func _on_BoutonCreer_mouse_entered():
	
	get_child(0).get_child(0).get_child(0).get_child(1).playing = true

#AESTHETIC (stops little arrow animation on mouse entered)
func _on_BoutonCreer_mouse_exited():
	get_child(0).get_child(0).get_child(0).get_child(1).playing = false
