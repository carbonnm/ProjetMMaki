extends Node

var Save := preload("Save.gd").new()
var SVGParser := preload("SVGParser.gd").new()


var save_nodes: Array = []


func set_save_nodes(nodes: Array):
	save_nodes = nodes

func export_to_svg():
	Save.set_save_nodes(save_nodes)
	Save.save()
	
	SVGParser.create_structure()
	SVGParser.get_next_element(SVGParser.get_SVG(), "BaliseHeader", "svg", SVGParser.get_cursor())
	SVGParser.get_next_element(SVGParser.get_SVG(), "Line", "", SVGParser.get_cursor())
#	SVGParser.get_next_element(SVGParser.get_SVG(), "Line", "", SVGParser.get_cursor())
	
	var current_save: Dictionary = Save.get_current_save()
	var lines: Array = current_save["Line2D"]
	for line in lines:
		SVGParser.create_path_balise(line)
	
	SVGParser.display_SVG(SVGParser.get_SVG())





#	if event is InputEventKey and event.scancode == KEY_KP_9:
#		var parent_node: Node = Utils.get_match_string_node("Elements", self)
#		Save.set_save_nodes([parent_node])
#		Save.save()
#		print(Save.saves[0]["Line2D"][0].points[0])
	
#	var svg = SVG.new()
#	var svg_string = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
#	svg_string += "<svg width=\"400\" height=\"400\" viewBox=\"0 0 400 400\" xmlns=\"http://www.w3.org/2000/svg\">\n"
#	svg_string += "\t<rect x=\"50\" y=\"50\" width=\"300\" height=\"height_value\" fill=\"#FFDAB9\"/>\n"
#	svg_string += "\t<rect x=\"50\" y=\"50\" width=\"\" height=\"300\" fill=\"#000000\"/>\n"
#	svg_string += "\t<circle cx=\"200\" cy=\"200\" r=\"100\" fill=\"#F08080\"/>\n"
#	svg_string += "\t<text x=\"200\" y=\"240\" font-size=\"30\" fill=\"#000000\" text-anchor=\"middle\">Hello, world!</text>\n"
#	svg_string += "</svg>"
#
#	print("Tests")
#	var origin_index = 110
#	var bounds = svg.get_next_element(svg_string, "BaliseValue", origin_index)
#	print(svg_string[origin_index])
#	print(bounds)
#	svg.display_between_bounds(svg_string, bounds)

#var balises: Dictionary = {
#	"svg": {
#		"width": "",
#		"height": "",
#		"viewbox": "",
#	},
#	"path": {
#		"d": "",
#		"stroke": ""
#	},
#	"text": {
#		"x": "",
#		"y": "",
#		"font_size": "",
#		"text_anchor": "",
#		"fill": "",
#		"value": ""
#	},
#	"image": {
#		"x": "",
#		"y": "",
#		"width": "",
#		"height": "",
#		"xlink:ref": ""
#	}
#}
