extends AState

var SVGCompiler := preload("res://SavePlugin/SVGCompiler.gd")

func enter():
	var viewport_center = canvas._camera.global_position

	canvas.get_node("SavePopUpConfirmation").rect_position = viewport_center
	canvas.get_node("SavePopUpConfirmation").visible = true

func physics_process(delta) -> IState:
	var spuc: Node = canvas.get_node("SavePopUpConfirmation")
	
	if spuc.validation:
		var save_node = canvas.Utils.get_match_string_node("Elements", canvas)
		var background_node = canvas.Utils.get_match_string_node("BackgroundColor", canvas)
		var svg_compiler = SVGCompiler.new([save_node, background_node])
		svg_compiler.export_to_svg()
	
	if spuc.visible:
		return null
	
	else:
		return switch_to_previous_state()
