extends Node2D

export var mainScene : PackedScene

func _on_BoutonCreer_button_up():
	get_tree().change_scene("res://Newcanvasoptions.tscn")

#AESTHETIC (launches little arrow animation on mouse entered)
func _on_BoutonCreer_mouse_entered():
	get_child(2).get_child(1).playing = true

#AESTHETIC (stops little arrow animation on mouse entered)
func _on_BoutonCreer_mouse_exited():
	get_child(2).get_child(1).playing = false

#AESTHETIC (launches little arrow animation on mouse entered)
func _on_BoutonOptions_mouse_entered():
	get_child(3).get_child(1).playing = true

#AESTHETIC (stops little arrow animation on mouse entered)
func _on_BoutonOptions_mouse_exited():
	get_child(3).get_child(1).playing = false
