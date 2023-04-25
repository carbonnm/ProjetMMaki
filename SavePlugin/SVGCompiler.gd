extends Node

var Utils := preload("Utilities.gd").new()

var Save := preload("Save.gd").new()
var SVGSyntax := preload("SVGSyntax.gd").new()

const SAVE_FILE: String = "res://SavePlugin/Saves/mon_fichier_svg.svg"
const MIN_MARGIN: Vector2 = Vector2(100,100)

var save_nodes: Array = []

"""
Function that set nodes to save. Childs nodes of specified
nodes are also saved. If a child of an already specified 
parent is given, it will be saved twice.

Parameters:
-----------
nodes: Nodes to save. (Array)
"""
func _init(nodes: Array) -> void:
	save_nodes = nodes

func export_to_svg() -> void:
	# Create a save of specified nodes.
	var save: Dictionary = save()
	
	# Construct the syntax element.
	var construction: Dictionary = construct_syntax_element(save)
	
	# Create the SVG string.
	var svg_string: String = SVGSyntax.get_svg_string(construction)
	
	# Create the SVG file.
	var file: File = File.new()
	var opened: int = file.open(SAVE_FILE, File.WRITE)
	if opened != 0:
		print("Error on file opening.")
	else:
		file.store_string(svg_string)
		file.close()

func construct_syntax_element(save: Dictionary) -> Dictionary:
	# Setup style balise.
	var defs_balise: Dictionary
	if save["Label"] != []:
		var custom_svg_style_path: String = ProjectSettings.globalize_path(save["Label"][0].get_font("font").font_data.font_path)
		var style_balise: Dictionary = SVGSyntax.get_svg_style(custom_svg_style_path)
		# Setup defs and add the style balise to him.
		defs_balise = SVGSyntax.get_defs()
		defs_balise = SVGSyntax.add_svg_child(defs_balise, style_balise)
	else:
		defs_balise = {}
	
	# Setup svg balise.
	var svg_viewbox: Array = get_save_corners(save)
	var origin: Vector2 = svg_viewbox[0]
	var size: Vector2 = svg_viewbox[1] - svg_viewbox[0]
	# Add a Margin
	var margin: Vector2 = Vector2(max(size.x/10, MIN_MARGIN.x), max(size.y/10, MIN_MARGIN.y))
	origin -= margin
	size += 2*margin
	var svg_balise: Dictionary = SVGSyntax.get_svg(origin, size, defs_balise)
	
	# Setup a svg rectangle for the image background and add it to svg childs.
	var background_color: Color = save["BackgroundColor"]
	var rect_balise: Dictionary = SVGSyntax.get_svg_rect(origin, size, background_color)
	svg_balise = SVGSyntax.add_svg_child(svg_balise, rect_balise)
	
	# Setup paths balises and add them as svg child.
	for line in save["Line2D"]:
		var path_d: PoolVector2Array = line.points
		var path_stroke: Color = line.default_color
		var path_stroke_width_vector: Vector2 = Vector2(line.width,line.width) * line.scale
		var path_stroke_width: int = int(path_stroke_width_vector.distance_to(Vector2.ZERO))
		var path_balise: Dictionary = SVGSyntax.get_svg_path(path_d, path_stroke, path_stroke_width)
		svg_balise = SVGSyntax.add_svg_child(svg_balise, path_balise)
	
	# Setup Labels and add them as svg child.
	for text_edit in save["Label"]:
		var text_label: String = text_edit.text
		var text_position: Vector2 = text_edit.rect_position + text_edit.rect_size/2
		var text_font_size_vector: Vector2 = text_edit.get_font("font").size * text_edit.rect_scale
		var text_font_size: int = int((text_font_size_vector.x + text_font_size_vector.y)/2)
		var text_font_family: String = "custom-font-family" #text_edit.get_font("font").get_name()
		var text_fill: Color = text_edit.get("custom_colors/font_color")
		var text_rotation: float = rad2deg(text_edit.rect_rotation)
		var text_edit_balise: Dictionary = SVGSyntax.get_svg_text(text_label, text_position, text_font_size, text_font_family, text_fill, text_rotation)
		svg_balise = SVGSyntax.add_svg_child(svg_balise, text_edit_balise)
	
	# DEPRECATED
	# Setup sprites and add them as svg child.
	for sprite in save["Sprite"]:
		var image_position: Vector2 = Vector2.ZERO
		var image_size: Vector2 = Vector2.ZERO
		var image_href: String = ""
		var sprite_balise: Dictionary = SVGSyntax.get_svg_image(image_position, image_size, image_href)
		svg_balise = SVGSyntax.add_svg_child(svg_balise, sprite_balise)
	
	# Setup the syntax bloc with the previously setup svg balise
	var syntax_block: Dictionary = SVGSyntax.get_syntax(svg_balise)
	
	return syntax_block

"""
Function create a save of specified nodes and return
the save.

Returns:
--------
The save made. (Dictionary)
"""
func save() -> Dictionary:
	Save.set_save_nodes(save_nodes)
	var save: Dictionary = Save.save()
	return save

"""
Return an array containing the upper-left and the bottom-right 
corner in this order from the save.

!!! The upper-left and bottom-right are according to Godot 
scene representation wich has his y axis downside. It means
that the upper-left position is lower than bottom-right one, 
which could be confusing. !!!

Parameters:
-----------
save: The save to get corners positions. (Dictionary)

Returns:
--------
The positions containing the upper_left and the bottom-right 
corner in this order. (Array)
"""
func get_save_corners(save: Dictionary) -> Array:
	var positions: PoolVector2Array = PoolVector2Array()
	
	for line in save["Line2D"]:
		positions.append_array(line.points)
	
	for text_edit in save["Label"]:
		var text_shape: Vector2 = (text_edit.rect_size - text_edit.rect_position)*text_edit.rect_scale
		var text_origin: Vector2 = text_edit.rect_position + text_edit.rect_size/2 - text_shape/2
		var text_size: Vector2 = text_origin + text_shape
		positions.append(text_origin)
		positions.append(text_size)
	
	for sprite in save["Sprite"]:
		var sprite_origin: Vector2 = sprite.position + Vector2(0,-sprite.size.y)
		positions.append(sprite_origin)
		positions.append(sprite_origin+sprite.size)
	
	return Utils.get_positions_corners(positions)
