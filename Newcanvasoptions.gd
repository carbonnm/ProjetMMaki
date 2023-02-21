extends Node2D




# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

#Moves to the new canvas 
func _on_BoutonCreer_button_up():
	var name_canvas = get_child(0).get_child(0).get_child(3).new_name
	#Need for a name to have been entered !
	if not(name_canvas ==""):
		SceneSwitcher.change_scene("Main.tscn", {"namecanvas":name_canvas})
	else:
		print("Besoin d'un titre pour le nouveau canvas, Faudra afficher un ptit message ~")
	
	
#AESTHETIC (launches little arrow animation on mouse entered)
func _on_BoutonCreer_mouse_entered():
	
	get_child(0).get_child(0).get_child(0).get_child(1).playing = true

#AESTHETIC (stops little arrow animation on mouse entered)
func _on_BoutonCreer_mouse_exited():
	get_child(0).get_child(0).get_child(0).get_child(1).playing = false
