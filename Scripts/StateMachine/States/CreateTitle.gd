extends AState

func exit() -> void:
	canvas.snapshots.create_snapshot()

func input(_event: InputEvent) -> IState:
	canvas.get_node("Titlemenuaddition/Inputtitle").clear()
	if Input.is_action_pressed("1"):
		canvas.get_node("Titlemenuaddition").type_title = 1
		
		#changes the appearance of the title menu addition following what's being created
		canvas.get_node("Titlemenuaddition/Titlemenu").visible  = true
		canvas.get_node("Titlemenuaddition/Subtitlemenu").visible  = false
		canvas.get_node("Titlemenuaddition/Subsubtitlemenu").visible  = false
		
		canvas.get_node("Titlemenuaddition/Inputtitle").placeholder_text = "Titre"
		
		#Puts the title menu addition where it was clicked on the screen 
		var size_title_menu_x = canvas.get_node("Titlemenuaddition/ColorRect").get_global_rect().size.x
		var size_title_menu_y = canvas.get_node("Titlemenuaddition/ColorRect").get_global_rect().size.y
		canvas.get_node("Titlemenuaddition").rect_position.x = canvas._camera.get_camera_position().x - (size_title_menu_x/5)
		canvas.get_node("Titlemenuaddition").rect_position.y = canvas._camera.get_camera_position().y - (size_title_menu_y/5)
		canvas.get_node("Titlemenuaddition").visible = true

	elif Input.is_action_pressed("2"):
		canvas.get_node("Titlemenuaddition").type_title = 2
		#changes the appearance of the title menu addition following what's being created
		canvas.get_node("Titlemenuaddition/Subtitlemenu").visible  = true
		canvas.get_node("Titlemenuaddition/Subsubtitlemenu").visible  = false
		canvas.get_node("Titlemenuaddition/Titlemenu").visible  = false
		canvas.get_node("Titlemenuaddition/Inputtitle").placeholder_text = "Sous-titre"
		
		
		#Puts the title menu addition where it was clicked on the screen 
		var size_title_menu_x = canvas.get_node("Titlemenuaddition/ColorRect").get_global_rect().size.x
		var size_title_menu_y = canvas.get_node("Titlemenuaddition/ColorRect").get_global_rect().size.y
		canvas.get_node("Titlemenuaddition").rect_position.x = canvas._camera.get_camera_position().x - (size_title_menu_x/5)
		canvas.get_node("Titlemenuaddition").rect_position.y = canvas._camera.get_camera_position().y - (size_title_menu_y/5)
		
		canvas.get_node("Titlemenuaddition").visible = true
		
	elif Input.is_action_pressed("3"):
		canvas.get_node("Titlemenuaddition").type_title = 3
		
		#changes the appearance of the title menu addition following what's being created
		canvas.get_node("Titlemenuaddition/Subsubtitlemenu").visible  = true
		canvas.get_node("Titlemenuaddition/Titlemenu").visible  = false
		canvas.get_node("Titlemenuaddition/Subtitlemenu").visible  = false
		canvas.get_node("Titlemenuaddition/Inputtitle").placeholder_text = "Sous sous-titre"
		
		
		#Puts the title menu addition where it was clicked on the screen 
		var size_title_menu_x = get_node("Titlemenuaddition/ColorRect").get_global_rect().size.x
		var size_title_menu_y = get_node("Titlemenuaddition/ColorRect").get_global_rect().size.y
		canvas.get_node("Titlemenuaddition").rect_position.x = canvas._camera.get_camera_position().x - (size_title_menu_x/5)
		canvas.get_node("Titlemenuaddition").rect_position.y = canvas._camera.get_camera_position().y - (size_title_menu_y/5)
		canvas.get_node("Titlemenuaddition").visible = true
		#makes the right-click menu disappear faster
	
	canvas.get_node("TitleCreationPopUp").visible = false
	canvas.get_node("CanvasLayer/RightClickContainer").visible = false
	canvas.get_node("Titlemenuaddition/Inputtitle").grab_focus()
	return null

func physics_process(_delta: float) -> IState:
	if canvas.get_node("Titlemenuaddition").visible == false:
		return switch_to_previous_state()
	return null
	

func parametrized_call(args: Array) -> IState:
	if args[0] is int:
		canvas.get_node("Titlemenuaddition/Inputtitle").clear()
		if args[0] == 1:
			canvas.get_node("Titlemenuaddition").type_title = 1
			
			#changes the appearance of the title menu addition following what's being created
			canvas.get_node("Titlemenuaddition/Titlemenu").visible  = true
			canvas.get_node("Titlemenuaddition/Subtitlemenu").visible  = false
			canvas.get_node("Titlemenuaddition/Subsubtitlemenu").visible  = false
			
			canvas.get_node("Titlemenuaddition/Inputtitle").placeholder_text = "Titre"
			
			#Puts the title menu addition where it was clicked on the screen 
			var size_title_menu_x = canvas.get_node("Titlemenuaddition/ColorRect").get_global_rect().size.x
			var size_title_menu_y = canvas.get_node("Titlemenuaddition/ColorRect").get_global_rect().size.y
			canvas.get_node("Titlemenuaddition").rect_position.x = canvas._camera.get_camera_position().x - (size_title_menu_x/5)
			canvas.get_node("Titlemenuaddition").rect_position.y = canvas._camera.get_camera_position().y - (size_title_menu_y/5)
			canvas.get_node("Titlemenuaddition").visible = true
			#makes the right-click menu disappear faster
			canvas.get_node("TitleCreationPopUp").visible = false
			canvas.get_node("CanvasLayer/RightClickContainer").visible = false
		
		if args[0] == 2:
			canvas.get_node("Titlemenuaddition").type_title = 2
			#changes the appearance of the title menu addition following what's being created
			canvas.get_node("Titlemenuaddition/Subtitlemenu").visible  = true
			canvas.get_node("Titlemenuaddition/Subsubtitlemenu").visible  = false
			canvas.get_node("Titlemenuaddition/Titlemenu").visible  = false
			canvas.get_node("Titlemenuaddition/Inputtitle").placeholder_text = "Sous-titre"
			
			
			#Puts the title menu addition where it was clicked on the screen 
			var size_title_menu_x = canvas.get_node("Titlemenuaddition/ColorRect").get_global_rect().size.x
			var size_title_menu_y = canvas.get_node("Titlemenuaddition/ColorRect").get_global_rect().size.y
			canvas.get_node("Titlemenuaddition").rect_position.x = canvas._camera.get_camera_position().x - (size_title_menu_x/5)
			canvas.get_node("Titlemenuaddition").rect_position.y = canvas._camera.get_camera_position().y - (size_title_menu_y/5)
			
			canvas.get_node("Titlemenuaddition").visible = true
			#makes the right-click menu disappear faster
			canvas.get_node("TitleCreationPopUp").visible = false
			canvas.get_node("CanvasLayer/RightClickContainer").visible = false
			
		if args[0] == 3:
			canvas.get_node("Titlemenuaddition").type_title = 3
			
			#changes the appearance of the title menu addition following what's being created
			canvas.get_node("Titlemenuaddition/Subsubtitlemenu").visible  = true
			canvas.get_node("Titlemenuaddition/Titlemenu").visible  = false
			canvas.get_node("Titlemenuaddition/Subtitlemenu").visible  = false
			canvas.get_node("Titlemenuaddition/Inputtitle").placeholder_text = "Sous sous-titre"
			
			
			#Puts the title menu addition where it was clicked on the screen 
			var size_title_menu_x = canvas.get_node("Titlemenuaddition/ColorRect").get_global_rect().size.x
			var size_title_menu_y = canvas.get_node("Titlemenuaddition/ColorRect").get_global_rect().size.y
			canvas.get_node("Titlemenuaddition").rect_position.x = canvas._camera.get_camera_position().x - (size_title_menu_x/5)
			canvas.get_node("Titlemenuaddition").rect_position.y = canvas._camera.get_camera_position().y - (size_title_menu_y/5)
			canvas.get_node("Titlemenuaddition").visible = true
			#makes the right-click menu disappear faster
			canvas.get_node("TitleCreationPopUp").visible = false
			canvas.get_node("CanvasLayer/RightClickContainer").visible = false
		
	else :
		canvas.CreateTitle.create_new_title(args[0], canvas.custom.customization, canvas)
	canvas.get_node("Titlemenuaddition/Inputtitle").grab_focus()
	return null

func keyboard_input(_event: InputEvent) -> IState:
	var TMA: Control = canvas.get_node("Titlemenuaddition")
	if TMA.visible:
		if Input.is_action_just_pressed("ui_cancel"):
			canvas.get_node("Titlemenuaddition").hide()
			return switch_to_previous_state()
		
		return null
	
	return null
