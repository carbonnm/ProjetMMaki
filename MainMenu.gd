extends Node2D

export var mainScene : PackedScene
var donetimer = false
func _ready():
	var timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer) #to process
	timer.start() #to start


func _on_timer_timeout():
	
	var noderef = get_node("Nothingtoseehere")
	var speakref = get_node("Nothingtoseehere/Notaneasteregg/Duckspeak")
	noderef.visible = true
	
	if not donetimer:
		get_node("Nothingtoseehere/Notaneasteregg").playing = true
		speakref.percent_visible = 0.0
		speakref.visible_characters = 0
		yield(get_tree().create_timer(3), "timeout")
		var x = 1
		while x < speakref.bbcode_text.length():
			
			speakref.set("visible_characters",x)
			yield(get_tree().create_timer(0.05), "timeout")
			x+=9
		donetimer = true

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
	#("")
	pass

