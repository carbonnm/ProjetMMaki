extends Node2D

export var mainScene : PackedScene

#Going to the next scene (the new canvas options menu)
func _on_BoutonCreer_button_up():
	get_tree().change_scene("res://Scene/Newcanvasoptions.tscn")
	
#--------------------------------------------------------------------------
#--------------------------------------------------------------------------
#AESTHETIC (little arrow animation on creation and options button hovering)
#-------------------------

#launches little arrow animation on mouse entered
func _on_BoutonCreer_mouse_entered():
	get_node("ContainerBoutonCreer/Littlearrow").playing = true

#stops little arrow animation on mouse entered
func _on_BoutonCreer_mouse_exited():
	get_node("ContainerBoutonCreer/Littlearrow").playing = false

#launches little arrow animation on mouse entered
func _on_BoutonOptions_mouse_entered():
	get_node("ContainerBoutonOptions/Littlearrow").playing = true
	

#stops little arrow animation on mouse entered
func _on_BoutonOptions_mouse_exited():
	get_node("ContainerBoutonOptions/Littlearrow").playing = false


func _on_BoutonOptions_pressed():
	get_node("Namenotentered").visible = true

