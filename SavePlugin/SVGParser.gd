extends Node


var SVG: String = ""
var cursor: int = 0

################################################################################
# Getters ######################################################################
################################################################################

"""
Getter for SVG attribute.

Returns:
--------
The SVG attribute. (String)
"""
func get_SVG() -> String:
	return SVG

"""
Getter for cursor attribute.

Returns:
--------
The cursor attribute. (int)
"""
func get_cursor() -> int:
	return cursor

################################################################################
# Setters ######################################################################
################################################################################

"""
Setter for SVG attribute.

Parameters:
-----------
string: The string to set to SVG (String)
"""
func set_SVG(string: String) -> void:
	self.SVG = string

"""
Setter for cursor attribute.

Parameters:
-----------
index: The index to set to cursor (int)
"""
func set_cursor(index: int) -> void:
	self.cursor = index

"""
Function that inserts a string at cursor position in SVG.

Parameters:
-----------
string: The string to insert inside SVG. (String)
"""
func insert_SVG(string: String) -> void:
	self.SVG.insert(cursor, string)

"""
Function that removes a substring from SVG.

Parameters:
-----------
from: Index of the first letter to delete. (int)
to: Index of the last letter to delete.
"""
func remove_SVG(from: int, to: int) -> void:
	var SVG_begin: String = SVG.substr(0,from)
	var SVG_end: String = SVG.substr(to+1,SVG.length()-1)
	self.SVG = SVG_begin + SVG_end

################################################################################
# Checker ######################################################################
################################################################################

"""
Function that checks if the cursor is inside a balise from the SVG string.

Returns:
--------
True if the cursor is inside a balise, False else.
"""
func is_inside_balise() -> bool:
	if SVG[cursor] == "<":
		return true
	
	var c_index: Array = get_syntax_element_bounds(string, "EndOfBalise", "", origin_index)
	if c_index == []:
		return false
		
	var o_index: Array = get_syntax_element_bounds(string, "StartOfBalise", "", origin_index)
	if o_index == [] or o_index[0] < c_index[1]:
		return true
	
	return false

func line_num_of_character(line: String, character: String) -> int:
	var num_of_characters: int = 0
	for c in line:
		if c == character:
			num_of_characters += 1
		else:
			return num_of_characters
	
	return num_of_characters


func get_all_substr_bounds(string: String, bounds: Array, origin_index: int = 0, accu: Array = []) -> Array:
	var bounds_index: Array = get_substr_bounds(string, bounds, origin_index)
	if bounds_index != []:
		accu.append(bounds_index)
		if string.length() > bounds_index[1]+1:
			return get_all_substr_bounds(string, bounds, bounds_index[1]+1, accu)
	
	return accu

func get_substr_bounds(string: String, bounds: Array, origin_index: int = 0) -> Array:
	var start: String = bounds[0]
	var end: String = bounds[1]
	
	if start == "" and end == "":
		return []
	
	var start_index: int
	if start == "":
		start_index = origin_index
	else:
		start_index = string.find(start, origin_index)
	if start_index < 0:
		return []
	
	var end_index: int
	if end == "":
		end_index = start_index + start.length()-1
	else:
		end_index = string.find(end, start_index + start.length())
		end_index += end.length()-1
	if end_index < 0:
		return []
	
	return [start_index, end_index]

func get_rsubstr_index(string: String, bounds: Array, origin_index: int = 0) -> int:
	var start: String = bounds[0]
	var end: String = bounds[1]
	
	if start == "" and end == "":
		return -1
	
	var end_index: int
	if end == "":
		end_index = origin_index
	else:
		end_index = string.rfind(end, origin_index)
	
	var start_index: int
	if start == "":
		start_index = end_index
	else:
		start_index = string.rfind(start, end_index - end.length())
	
	return start_index



func get_adjacent_element(string: String, syntax_type: String, element_name: String, origin_index: int = 0, reverse: bool = false) -> Array:
	match syntax_type:
		"Line":
			if reverse:
				return get_prev_line(string, origin_index)
			else:
				return get_next_line(string, origin_index)
		"Balise":
			if reverse:
				return get_prev_balise(string, origin_index)
			else:
				return get_next_balise(string, origin_index)
		"Attribute":
			if reverse:
				return get_prev_attribute(string, origin_index)
			else:
				return get_next_attribute(string, origin_index)
		"BaliseValue":
			if reverse:
				return get_prev_balise_value(string, origin_index)
			else:
				return get_next_balise_value(string, origin_index)
		"AttributeValue":
			if reverse:
				return get_prev_attribute_value(string, origin_index)
			else:
				return get_next_attribute_value(string, origin_index)
		_:
			if reverse:
				return get_prev_syntax_element(string, syntax_type, element_name, origin_index)
			else:
				return get_next_syntax_element(string, syntax_type, element_name, origin_index)



func get_next_element(string: String, syntax_type: String, element_name: String = "", origin_index: int = 0) -> Array:
	var bounds: Array = get_adjacent_element(string, syntax_type, element_name, origin_index, false)
	self.cursor = bounds[0]
	return bounds

func get_prev_element(string: String, syntax_type: String, element_name: String = "", origin_index: int = 0) -> Array:
	var bounds: Array = get_adjacent_element(string, syntax_type, element_name, origin_index, true)
	self.cursor = bounds[0]
	return bounds

func get_current_element(string: String, syntax_type: String, element_name: String = "", origin_index: int = 0) -> Array:
	var bounds: Array = get_next_element(string, syntax_type, element_name, origin_index)
	bounds = get_prev_element(string, syntax_type, element_name, bounds[0])
	self.cursor = bounds[0]
	return bounds



func get_bounds_by_syntax(syntax_type: String, element_name: String = "") -> Array:
	var start: String
	var end: String
	match syntax_type:
		"BaliseHeader":
			start = "<" + element_name
			end = ">"
		"Balise":
			start = "<" + element_name
			end = "</" + element_name + ">"
		"AttributeHeader":
			start = element_name
			end = ""
		"Attribute":
			start = element_name + "=\""
			end = "\""
		"EndOfLine":
			start = "\n"
			end = ""
		"StartOfBalise":
			start = "<"
			end = ""
		"EndOfBalise":
			start = ""
			end = ">"
		"Space":
			start = " "
			end = ""
		"BeforeSpace":
			start = ""
			end = " "
		"Quote":
			start = "\""
			end = ""
		"BeforeQuote":
			start = ""
			end = "\""
		"Value":
			start = element_name + "_value"
			end = ""
		"EmptyValue":
			start = "\"\""
			end = ""
		_:
			return []
		
	return [start,end]

func get_syntax_element_bounds(string: String, syntax_type: String, element_name: String = "", origin_index: int = 0) -> Array:
	var bounds: Array = get_bounds_by_syntax(syntax_type, element_name)
	
	return get_substr_bounds(string, bounds, origin_index)

func get_next_syntax_index(string: String, syntax_type: String, element_name: String, origin_index: int = 0) -> int:
	var bounds: Array = get_bounds_by_syntax(syntax_type, element_name)
	
	return get_substr_bounds(string, bounds, origin_index)[0]
	
func get_prev_syntax_index(string: String, syntax_type: String, element_name: String, origin_index: int = 0) -> int:
	var bounds: Array = get_bounds_by_syntax(syntax_type, element_name)
	
	return get_rsubstr_index(string, bounds, origin_index)



func get_next_syntax_element(string: String, syntax_type: String, element_name: String, origin_index: int) -> Array:
	return get_syntax_element_bounds(string, syntax_type, element_name, origin_index)

func get_next_line(string: String, origin_index: int = 0) -> Array:
	origin_index = get_next_syntax_index(string, "EndOfLine", "", origin_index)+1
	
	if string[origin_index] == "\n":
		return [origin_index, origin_index]
	
	origin_index = get_next_syntax_index(string, "StartOfBalise", "", origin_index)
	
	return get_syntax_element_bounds(string, "EndOfLine", "", origin_index)

func get_next_balise(string: String, origin_index: int = 0) -> Array:
	origin_index = get_next_syntax_index(string, "StartOfBalise", "", origin_index)
	
	return get_syntax_element_bounds(string, "EndOfBalise", "", origin_index)

func get_next_attribute(string: String, origin_index: int = 0) -> Array:
	if is_inside_balise(string, origin_index):
		origin_index = get_next_syntax_index(string, "Space", "", origin_index)+1
		var start: int = origin_index
		origin_index = get_next_syntax_index(string, "Quote", "", origin_index)+1
		var end: int = get_next_syntax_index(string, "Quote", "", origin_index)
		return [start,end]
	else:
		origin_index = get_next_balise(string, origin_index)[0]
		return get_next_attribute(string, origin_index)

func get_next_balise_value(string: String, origin_index: int = 0) -> Array:
	var balise_bounds: Array = get_next_balise(string, origin_index)
	var start: int = get_next_syntax_index(string, "Space", "", balise_bounds[0])+1
	var balise_end: int = balise_bounds[1]
	
	var end: int = balise_end
	for c in range(0,balise_end-start):
		if not (string[balise_end - c] == "/" or string[balise_end - c] == ">"):
			return [start,end]
		
		end -= 1
	
	return [0,0]

func get_next_attribute_value(string: String, origin_index: int = 0) -> Array:
	var attribute_bounds: Array = get_next_attribute(string, origin_index)
	var start: int = get_next_syntax_index(string, "Quote", "", attribute_bounds[0])
	var end: int = attribute_bounds[1]
	return [start,end]

# DEPRECATED
func get_prev_syntax_element(string: String, syntax_type: String, element_name: String, origin_index: int) -> Array:
	return []
#func get_prev_syntax_element(string: String, syntax_type: String, element_name: String, origin_index: int) -> Array:
#	var bounds: Array = get_bounds_by_syntax(s)
#	return get_syntax_element_bounds(string, syntax_type, element_name, origin_index)

func get_prev_line(string: String, origin_index: int = 0) -> Array:
	origin_index = get_prev_syntax_index(string, "EndOfLine", "", origin_index)
	
	if string[origin_index-1] == "\n":
		return [origin_index, origin_index]
	
	origin_index = get_prev_syntax_index(string, "StartOfBalise", "", origin_index)
	
	return get_syntax_element_bounds(string, "EndOfLine", "", origin_index)

func get_prev_balise(string: String, origin_index: int = 0) -> Array:
	origin_index = get_prev_syntax_index(string, "StartOfBalise", "", origin_index)
	if is_inside_balise(string, origin_index):
		origin_index = get_prev_syntax_index(string, "StartOfBalise", "", origin_index)
	
	return get_syntax_element_bounds(string, "EndOfBalise", "", origin_index)

func get_prev_attribute(string: String, origin_index: int = 0) -> Array:
	if is_inside_balise(string, origin_index):
		origin_index = get_prev_syntax_index(string, "Space", "", origin_index)
		origin_index = get_prev_syntax_index(string, "Space", "", origin_index)+1
		var start: int = origin_index
		origin_index = get_next_syntax_index(string, "Quote", "", origin_index)+1
		var end: int = get_next_syntax_index(string, "Quote", "", origin_index)
		return [start,end]
	else:
		origin_index = get_prev_balise(string, origin_index)[1]
		return get_prev_attribute(string, origin_index)

func get_prev_balise_value(string: String, origin_index: int = 0) -> Array:
	origin_index = get_prev_balise(string, origin_index)[0]
	return get_next_balise_value(string, origin_index)

func get_prev_attribute_value(string: String, origin_index: int = 0) -> Array:
	origin_index = get_prev_attribute(string, origin_index)[0]
	return get_next_balise_value(string, origin_index)


func create_structure() -> String:
	SVG = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
	newline()
	SVG += "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"\" height=\"\" viewBox=\"\">"
	newline()
	newline()
	SVG += "</svg>"
	
	return SVG

func newline() -> void:
	SVG += "\n"

func htab() -> void:
	SVG += "\t"



func display_between_bounds(string: String, bounds: Array) -> void:
	print(string.substr(bounds[0],bounds[1]-bounds[0]+1))

func display_SVG(string: String) -> void:
	print(string)

func create_path_balise(line: Line2D) -> void:
	var path_balise: String = ""
	var d: String = PoolVector2Array_to_d_path(line.points)
	var stroke: String = line.default_color.to_html()
	# DEPRECATED
	var indent: String = ""
	
	path_balise = indent + "<path d=\"" + d + "\" stroke=\"" + stroke + "\" fill=\"transparent\" />"
	
	SVG = SVG.insert(cursor, path_balise)
	newline()
	
	cursor += path_balise.length() + 1

func PoolVector2Array_to_d_path(points: PoolVector2Array) -> String:
	var d: String = "M "
	for point in points:
		d += str(point.x) + "," + str(point.y) + " "
		if points[0] == point:
			d += "L "
	
	return d
