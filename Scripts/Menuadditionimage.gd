extends Node2D

#new chosen word
onready var chosen_word = ""
onready var images = []
var image
var current_selected_png

func _on_Closebutton_mouse_exited():
	get_node("ColorRect/Closebutton/Crossicon").playing = false


func _on_Closebutton_mouse_entered():
	get_node("ColorRect/Closebutton/Crossicon").playing = true


func _on_Closebutton_button_up():
	visible = false
	get_node("ColorRect/Closebutton/Crossicon").playing = false
	get_node("ColorRect/MarginContainer/Saveicon").playing = false

func _on_Image1_button_up():
	#SELECTION DE L'IMAGE
	
	var popup= get_owner().get_node("Pop_up")
	var dialog = popup.get_node("FileDialog")

	dialog.show()
	popup.visible = true
	
	#yield(get_tree().create_timer(20), "timeout")
	#DOITÊTRE UN .PNG
	#si image sélectionnée != .png
	#if not is_png():
		
	#	get_node("ColorRect/Tryagain").bbcode_text = "Les images doivent être au format [shake] .png! [/shake]"
	#	get_node("ColorRect/Image1")["custom_styles/normal"].bg_color = Color("a72404")
	
	#else
	#AJOUT DANS LISTE IMAGE
	#images.append()
	
	#modification apparence
	#get_node("ColorRect/Image1")["custom_styles/normal"].bg_color = Color("8de51b")
	
	#Apparition du OK 
	#var okimage = get_node("ColorRect/Okimagedance")
	#okimage.visible=true
	#okimage.play("dance")
	
	
	#Open de la scène avec le folder qui s'ouvre

func _on_Image2_button_up():
	#SELECTION DE L'IMAGE
	$FileDialog.set_current_path("C://Users/")
	var popup= get_owner().get_node("Pop_up")
	popup.visible = true
	popup.get_node("FileDialog").show()
	
	#DOITÊTRE UN .PNG
	#si image sélectionnée != .png
	#get_node("ColorRect/Tryagain").bbcode_text = "Les images doivent être au format [shake] .png! [/shake]"
	#get_node("ColorRect/Image2")["custom_styles/normal"].bg_color = Color("a72404")
	
	#else
	#AJOUT DANS LISTE IMAGE
	#images.append()
	
	#modification apparence
	#get_node("ColorRect/Image2")["custom_styles/normal"].bg_color = Color("8de51b")
	
	
	#Apparition du OK 
	#var okimage = get_node("ColorRect/Okimagedance2")
	#okimage.visible=true
	#okimage.play("dance")



func _on_Image3_button_up():
	#SELECTION DE L'IMAGE
	$FileDialog.set_current_path("C://Users/")
	var popup= get_owner().get_node("Pop_up")
	popup.visible = true
	popup.get_node("FileDialog").show()
	
	#DOITÊTRE UN .PNG
	#si image sélectionnée != .png
	#get_node("ColorRect/Tryagain").bbcode_text = "Les images doivent être au format [shake] .png! [/shake]"
	#get_node("ColorRect/Image3")["custom_styles/normal"].bg_color = Color("a72404")
	
	#else
	#AJOUT DANS LISTE IMAGE
	#images.append()
	
	#modification apparence
	#get_node("ColorRect/Image3")["custom_styles/normal"].bg_color = Color("8de51b")
	
	
	#Apparition du OK 
	#var okimage = get_node("ColorRect/Okimagedance3")
	#okimage.visible=true
	#okimage.play("dance")


func _on_Image4_button_up():
	#SELECTION DE L'IMAGE
	$FileDialog.set_current_path("C://Users/")
	var popup= get_owner().get_node("Pop_up")
	popup.visible = true
	popup.get_node("FileDialog").show()
	
	#DOITÊTRE UN .PNG
	#si image sélectionnée != .png
	#get_node("ColorRect/Tryagain").bbcode_text = "Les images doivent être au format [shake] .png! [/shake]"
	#get_node("ColorRect/Image4")["custom_styles/normal"].bg_color = Color("a72404")
	
	#ELSE
	
	#AJOUT DANS LISTE IMAGE
	#images.append()
	
	#modification apparence
	#get_node("ColorRect/Image4")["custom_styles/normal"].bg_color = Color("8de51b")
	
	
	
	#Apparition du OK 
	#var okimage = get_node("ColorRect/Okimagedance4")
	#okimage.visible=true
	#okimage.play("dance")



func _on_Okbutton_button_up():
	
	chosen_word = get_node("ColorRect/NouveaumotInput").new_name
	if not (chosen_word==""):
		pass
	#check si mot existe pas encore dans répertoires 
	#si ko
	#get_node("ColorRect/Tryagain").bbcode_text = "Le mot [shake] .png! [/shake] a déjà été ajouté!"
	
	#si ok 
	#si il n'y a pas 4 images dans la liste
		#if images.size() != 4
		# #get_node("ColorRect/Tryagain").bbcode_text = "Vous devez sélectionner [shake] 4 [/shake] images!"
	
		#else
		#créer un nouveau répertoire avec le mot (lui enlever les accents?)
		#renommer les images
		#les ajouter dans le répertoire crée 
	
	
	#si aucun mot n'a été entré
	else:
		get_node("ColorRect/Tryagain").bbcode_text = "Il faut entrer un [tornado] mot [/tornado]  !"
		
		
func _on_Okbutton_mouse_entered():
	get_node("ColorRect/MarginContainer/Saveicon").playing = true


func _on_Okbutton_mouse_exited():
	get_node("ColorRect/MarginContainer/Saveicon").playing = false




func is_png():
	return current_selected_png
#receives the selected images' path and checks whether it's a .png
func _on_Pop_up_chosen_image(paths):
	
	current_selected_png = paths[0].ends_with(".png")
	
	print("signalworked ",current_selected_png)




func _on_FileDialog_files_selected(paths):
	if(paths.size()>1):
		emit_signal("too_many_selected")
	else:
		if not (paths[0].ends_with(".png")):
			#checks whether it's a png 
			emit_signal("png_ko")
		else:
			
			var dir = Directory.new()
			dir.open("res://Assets")
			
			var image_file = File.new()
			image_file.open(paths[0], File.READ)
			image_file.close()
			
			
			dir.copy(paths[0], "res://Assets/temporary_dir/duckeyeclosemouthclose.png")
			print(image_file)
			
			
			get_node("../Pop_up/Ok_menu").visible = true
			#emits the signal that will be received by the Menuadditionimagescript
			#emit_signal("chosen_image",paths)
			#visible = false
			#print(paths)
			
