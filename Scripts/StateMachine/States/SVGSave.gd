extends AState

var SVGCompiler := preload("res://SavePlugin/SVGCompiler.gd")

func enter():
	canvas.get_node("SavePopUpConfirmation").rect_position = Vector2(400, 200)
	canvas.get_node("SavePopUpConfirmation").visible = true

func input(_event: InputEvent) -> IState:
	if canvas.get_node("SavePopUpConfirmation").validation == null:
		return null
	
	if canvas.get_node("SavePopUpConfirmation").validation:

		var save_node = canvas.Utils.get_match_string_node("Elements", canvas)
		var background_node = canvas.Utils.get_match_string_node("BackgroundColor", canvas)
		var svg_compiler = SVGCompiler.new([save_node, background_node])
		svg_compiler.export_to_svg()

	return switch_to_previous_state()
