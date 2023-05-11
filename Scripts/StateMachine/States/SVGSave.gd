extends AState

var SVGCompiler := preload("res://SavePlugin/SVGCompiler.gd")

func enter():
	var viewport_center = canvas._camera.global_position

	canvas.get_node("CanvasLayer/SavePopUpConfirmation").rect_position = viewport_center
	canvas.get_node("CanvasLayer/SavePopUpConfirmation").visible = true
	canvas.get_node("CanvasLayer/RightClickContainer").visible = false

func physics_process(_delta) -> IState:
	var spuc: Node = canvas.get_node("CanvasLayer/SavePopUpConfirmation")
	
	if spuc.validation:
		var save_node = canvas.Utils.get_match_string_node("Elements", canvas)
		var background_node = canvas.Utils.get_match_string_node("BackgroundColor", canvas)
		var svg_compiler = SVGCompiler.new([save_node, background_node])
		svg_compiler.export_to_svg()
	
	if spuc.visible:
		return null
	
	else:
		return switch_to_previous_state()

func keyboard_input(_event: InputEvent) -> IState:
	var spuc: Node = canvas.get_node("CanvasLayer/SavePopUpConfirmation")
	if spuc.visible:
		if Input.is_action_just_pressed("ui_cancel"):
			spuc.hide()
			return switch_to_previous_state()
			
		if Input.is_action_just_pressed("ui_accept"):
			var save_node = canvas.Utils.get_match_string_node("Elements", canvas)
			var background_node = canvas.Utils.get_match_string_node("BackgroundColor", canvas)
			var svg_compiler = SVGCompiler.new([save_node, background_node])
			svg_compiler.export_to_svg()
			
			spuc.hide()
			return switch_to_previous_state()
		
		return null
	
	return null
