extends Node

var syntax: Dictionary = {
	"xml": "",
	"doctype": "",
	"svg": {}
}
var xml: String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
var doctype: String = "<!DOCTYPE svg>"
var svg: Dictionary = {
	"name": "svg",
	"attributes": {
		"viewBox": "",
		"xmlns": "http://www.w3.org/2000/svg",
	},
	"defs": {},
	"children": []
}
var defs: Dictionary = {
	"name": "defs",
	"attributes": {},
	"children": []
}
var style: Dictionary = {
	"name": "style",
	"attributes": {},
	"label": "",
	"children": []
}
var rect: Dictionary = {
	"name": "rect",
	"attributes": {
		"x": 0,
		"y": 0,
		"width": 0,
		"height": 0,
		"fill": "#ffffff"
	},
	"children": []
}
var path: Dictionary = {
	"name": "path",
	"attributes": {
		"d": "",
		"stroke": "black",
		"stroke-width": 12,
		"fill": "none"
	},
	"children": []
}
var text: Dictionary = {
	"name": "text",
	"attributes": {
		"x": 0,
		"y": 0,
		"font-size": 12,
		"font-family": "custom-font-family",
		"fill": "black",
		"text-anchor": "middle",
		"dominant-baseline": "middle",
		"transform": "rotate(0 0 0)"
	},
	"label": "",
	"children": []
}
var image: Dictionary = {
	"name": "image",
	"attributes": {
		"x": 0,
		"y": 0,
		"width": 0,
		"height": 0,
		"href": ""
	},
	"children": []
}

"""
Function that returns a string witch is the construction
formated to the SVG format.

Parameters:
-----------
construction: The construction. (Dictionary)

Returns:
--------
The SVG formated String. (String)
"""
func get_svg_string(construction: Dictionary) -> String:
	var svg_string: String = ""
	
	# Travel the construction to create the svg String.
	for balise in construction.values():
		
		# If construction value is a String (Balise), then 
		# add it to svg_string and make a new line.
		if balise is String:
			svg_string += balise + "\n"
		
		# Else, its a dynamic balise to construct.
		else:
			if balise["children"] != []:
				svg_string += get_balise_block_string(balise)
			else:
				svg_string += get_balise_string(balise)
	
	return svg_string

"""
Function that returns a string witch is the constructed
balise block formated to the SVG format.

Parameters:
-----------
balise: The balise block. (Dictionary)

Returns:
--------
The SVG formated String. (String)
"""
func get_balise_block_string(balise: Dictionary) -> String:
	var balise_block_string: String = "<" + balise["name"]
	
	# Travel the balise attributes to add them to the balise block.
	balise_block_string += get_balise_attributes_string(balise)
	
	# Close the balise and make 2 new lines.
	balise_block_string += ">\n\n"
	
	# Travels balise block values to add same level balises block.
	for key in balise:
		if balise[key] is Dictionary and balise[key].size() != 0 and key != "attributes":
			balise_block_string += get_balise_block_string(balise[key]) + "\n"
	
	# Travel childs to add them to balise block.
	var index: int = 0
	for child in balise["children"]:
		balise_block_string += "\t"
		
		# Make a new line if precedent balise was not the same kind of balise
		if index > 0 and child["name"] != balise["children"][index-1]["name"]:
			balise_block_string += "\n\t"
		
		if child["children"] != []:
			balise_block_string += get_balise_block_string(child)
		else:
			balise_block_string += get_balise_string(child)
		
		index += 1
	
	# Make a new line and close the balise block.
	balise_block_string += "\n</" + balise["name"] + ">\n"
	
	return balise_block_string

"""
Function that returns a string witch is the constructed
balise formated to the SVG format.

Parameters:
-----------
balise: The balise. (Dictionary)

Returns:
--------
The SVG formated String. (String)
"""
func get_balise_string(balise: Dictionary) -> String:
	var balise_string: String = "<" + balise["name"]
	
	# Travel the balise attributes to add them to the balise block
	# and close the balise.
	balise_string += get_balise_attributes_string(balise) + ">"
	
	# Add label if it exists one.
	if balise.has("label"):
		balise_string += balise["label"]
	
	# Add a tab if last charact was a new line
	if balise_string[-1] == "\n":
		balise_string += "\t"
	
	# Close the balise.
	balise_string += "</" + balise["name"] + ">"
	
	# Make a new line
	balise_string += "\n"
	
	return balise_string

"""
Function that returns a string witch is the constructed
balise attributes formated to the SVG format.

Parameters:
-----------
balise: The attributes block. (Dictionary)

Returns:
--------
The SVG formated String. (String)
"""
func get_balise_attributes_string(balise: Dictionary) -> String:
	var balise_attributes_string: String = ""
	
	# Travel the balise attributes to add them to the balise block.
	for attribute in balise["attributes"]:
		var attribute_value: String = str(balise["attributes"][attribute])
		balise_attributes_string += " " + attribute + "=\"" + attribute_value + "\""
	
	return balise_attributes_string

"""
Function that returns a syntax dictionary.

Parameters:
-----------
svg_block: The svg block of the svg image. (Dictionary)

Returns:
--------
The syntax dictionary created. (Dictionary)
"""
func get_syntax(svg_block: Dictionary) -> Dictionary:
	var dup_syntax: Dictionary = syntax.duplicate(true)
	dup_syntax["xml"] = xml
	dup_syntax["doctype"] = doctype
	dup_syntax["svg"] = svg_block
	return dup_syntax

"""
Function that returns an svg dictionary.

Parameters:
-----------
origin: The starting position of the svg image. (Vector2)
size: The size of svg image. (Vector2)

Returns:
--------
The svg dictionary created. (Dictionary)
"""
func get_svg(origin: Vector2, size: Vector2, defs_balise: Dictionary = {}) -> Dictionary:
	var dup_svg: Dictionary = svg.duplicate(true)
	dup_svg["attributes"]["viewBox"] = str(origin.x) + " " + str(origin.y) + " " + str(size.x) + " " + str(size.y)
	dup_svg["defs"] = defs_balise
	return dup_svg

"""
Function that returns a defs balise dictionary.

Returns:
--------
The defs balise dictionary created. (Dictionary)
"""
func get_defs() -> Dictionary:
	return defs.duplicate(true)

"""
Function that returns an svg style dictionary.

Parameters:
-----------
custom_font_family_path: Path of the custom font family. (String)

Returns:
The svg style dictionary created. (Dictionary)
"""
func get_svg_style(custom_font_family_path: String) -> Dictionary:
	var dup_style: Dictionary = style.duplicate(true)
	dup_style["label"] = get_style_label("custom-font-family", custom_font_family_path)
	return dup_style

"""
Function that returns a svg rectangle dictionary.

Parameters:
-----------
position: Position of the rectangle. (Vector2)
size: Size of the rectangle. (Vector2)
fill: Color of the rectangle. (Color - default: Color(0,0,0))

Returns:
--------
The svg rectangle dictionary created. (Dictionary)
"""
func get_svg_rect(position: Vector2, size: Vector2, fill: Color = Color(0,0,0)) -> Dictionary:
	var dup_rect: Dictionary = rect.duplicate(true)
	dup_rect["attributes"]["x"] = position.x
	dup_rect["attributes"]["y"] = position.y
	dup_rect["attributes"]["width"] = size.x
	dup_rect["attributes"]["height"] = size.y
	dup_rect["attributes"]["fill"] = "#" + fill.to_html().substr(2)
	return dup_rect

"""
Function that returns an svg path dictionary.

Parameters:
-----------
d: Positions of the path. (PoolVector2Array)
stroke: Color of the path. (Color - default: Color(0,0,0))
stroke_width: Width of the path. (int - default: 12)

Returns:
--------
The svg path dictionary created. (Dictionary)
"""
func get_svg_path(d: PoolVector2Array, stroke: Color = Color(0,0,0), stroke_width: int = 12) -> Dictionary:
	var dup_path: Dictionary = path.duplicate(true)
	dup_path["attributes"]["d"] = PoolVector2Array_to_d_path(d)
	dup_path["attributes"]["stroke"] = "#" + stroke.to_html().substr(2)
	dup_path["attributes"]["stroke-width"] = stroke_width
	return dup_path

"""
Function that returns an svg text dictionary.

Parameters:
-----------
label: Label of the text. (String)
position: Position of the text. (Vector2)
font_size: Font size of the text. (int)
font_family: Font family of the text. (String - default = "Arial")
fill: Color of the text: (Color - default = Color(0,0,0))

Returns:
--------
The svg text dictionary created. (Dictionary)
"""
func get_svg_text(label: String, position: Vector2, font_size: int, font_family: String = "custom-font-family", fill: Color = Color(0,0,0), rotation: float = 0.0) -> Dictionary:
	var dup_text: Dictionary = text.duplicate(true)
	dup_text["label"] = label
	dup_text["attributes"]["x"] = position.x
	dup_text["attributes"]["y"] = position.y
	dup_text["attributes"]["font-size"] = font_size
	dup_text["attributes"]["font-family"] = font_family
	dup_text["attributes"]["fill"] = "#" + fill.to_html().substr(2)
	dup_text["attributes"]["text-anchor"] = "middle"
	dup_text["attributes"]["dominant-baseline"] = "middle"
	dup_text["attributes"]["transform"] = "rotate(" + str(rotation) + " " + str(position.x) + " " + str(position.y) + ")"
	return dup_text

"""
Function that returns an svg image dictionary.

Parameters:
-----------
position: Position of the image. (Vector2)
size: Size of the image. (Vector2)
href: Reference to the image. (String)

Returns:
--------
The svg image syntax dictionary created. (Dictionary)
"""
func get_svg_image(position: Vector2, size: Vector2, href: String) -> Dictionary:
	var dup_image = image.duplicate(true)
	dup_image["attributes"]["x"] = position.x
	dup_image["attributes"]["y"] = position.y
	dup_image["attributes"]["width"] = size.x
	dup_image["attributes"]["height"] = size.y
	dup_image["attributes"]["href"] = href
	return dup_image

"""
Function that add a child dictionary to the parent dictionary and returns the
parent.

Parameters:
-----------
parent: The parent dictionary. (Dictionary)
child: The child dictionary. (Dictionary)

Returns:
--------
The parent to whom a child has been added. (Dictionary)
"""
func add_svg_child(parent: Dictionary, child: Dictionary) -> Dictionary:
	parent["children"].append(child)
	return parent

"""
Function that create the style balise label string according to 
the path of the custom font family and add it a name.

Parameters:
-----------
custom_font_family_name: Name of the custom font family (String)
custom_font_family_path: Path of the custom font family (String)

Returns:
--------
The label for the style balise. (String)
"""
func get_style_label(custom_font_family_name: String = "custom-font-family", custom_font_family_path: String = "/") -> String:
	var style_label: String = "\n\t\t@font-face {\n"
	style_label += "\t\t\tfont-family: \"" + custom_font_family_name + "\";\n"
	style_label += "\t\t\tsrc: url(\"" + custom_font_family_path + "\");\n\t\t}\n"
	return style_label

"""
Function that convert PoolVector2Array positions to d attribute 
syntax of svg path.

Parameters:
-----------
points: Positions to convert. (PoolVector2Array)

Returns:
--------
The converted positions. (String)
"""
func PoolVector2Array_to_d_path(points: PoolVector2Array) -> String:
	var d: String = "M "
	for point in points:
		d += str(point.x) + "," + str(point.y) + " "
		if points[0] == point:
			d += "L "
	
	return d

"""
Function that displays a construction into a SVG syntax format.

Parameters:
-----------
construction: The construction. (Dictionary)
"""
func display_svg_string(construction: Dictionary) -> void:
	print(get_svg_string(construction))
