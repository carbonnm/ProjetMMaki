extends Node

var xml: String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
var doctype: String = "<!DOCTYPE svg>"
var svg: Dictionary = {
	"name": "svg",
	"attributes": {
		"width": 0,
		"height": 0,
		"xmlns": "http://www.w3.org/2000/svg"
	},
	"children": []
}
var path: Dictionary = {
	"name": "path",
	"attributes": {
		"d": "",
		"fill": "black"
	},
	"children": []
}
var text: Dictionary = {
	"name": "text",
	"attributes": {
		"x": 0,
		"y": 0,
		"font-size": 12,
		"font-family": "Arial",
		"fill": "black",
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
Function that returns an svg syntax dictionary.

Parameters:
-----------
size: The size of svg image. (Vector2)

Returns:
--------
The svg syntax dictionary created. (Dictionary)
"""
func get_svg(size: Vector2) -> Dictionary:
	var dup_svg: Dictionary = svg.duplicate(true)
	dup_svg["attribute"]["width"] = size.x
	dup_svg["attribute"]["height"] = size.y
	return dup_svg

"""
Function that returns an svg path syntax dictionary.

Parameters:
-----------
d: Positions of the path. (PoolVector2Array)
fill: Color of the path. (Color - default: Color(0,0,0))

Returns:
--------
The svg path syntax dictionary created. (Dictionary)
"""
func get_svg_path(d: PoolVector2Array, fill: Color = Color(0,0,0)) -> Dictionary:
	var dup_path: Dictionary = path.duplicate(true)
	dup_path["attribute"]["d"] = PoolVector2Array_to_d_path(d)
	dup_path["attribute"]["fill"] = fill.to_html()
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
The svg text syntax dictionary created. (Dictionary)
"""
func get_svg_text(label: String, position: Vector2, font_size: int, font_family: String = "Arial", fill: Color = Color(0,0,0)) -> Dictionary:
	var dup_text: Dictionary = text.duplicate(true)
	dup_text["label"] = label
	dup_text["attribute"]["x"] = position.x
	dup_text["attribute"]["y"] = position.y
	dup_text["attribute"]["font-size"] = font_size
	dup_text["attribute"]["font-family"] = font_family
	dup_text["attribute"]["fill"] = fill.to_html()
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
	dup_image["attribute"]["x"] = position.x
	dup_image["attribute"]["y"] = position.y
	dup_image["attribute"]["width"] = size.x
	dup_image["attribute"]["height"] = size.y
	dup_image["attribute"]["href"] = href
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
