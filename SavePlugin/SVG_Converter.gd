extends Node


var SVG: String = ""
var cursor: int = 0

func _ready() -> void:
	create_structure()

func get_SVG() -> String:
	return SVG

func set_SVG(string: String) -> void:
	self.SVG = string

func set_cursor(index: int) -> void:
	self.cursor = index



func is_inside_balise(string: String, origin_index: int = 0) -> bool:
	var c_index: Array = get_syntax_element_index(string, "EndOfBalise", "", origin_index)
	if c_index == []:
		return false
		
	var o_index: Array = get_syntax_element_index(string, "StartOfBalise", "", origin_index)
	if o_index == [] or o_index[0] > c_index[0]:
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


func get_all_substr_indexes(string: String, bounds: Array, origin_index: int = 0, accu: Array = []) -> Array:
	var bounds_index: Array = get_substr_index(string, bounds, origin_index)
	if bounds_index != []:
		accu.append(bounds_index)
		if string.length() > bounds_index[1]+1:
			return get_all_substr_indexes(string, bounds, bounds_index[1]+1, accu)
	
	return accu

func get_substr_index(string: String, bounds: Array, origin_index: int = 0) -> Array:
	var start: String = bounds[0]
	var end: String = bounds[1]
	
	if start == "" and end == "":
		return []
	
	var start_index: int
	if start == "":
		start_index = 0
	else:
		start_index = string.find(start, origin_index)
	if start_index < 0:
		return []
	
	var end_index: int
	if end == "":
		end_index = start_index + start.length()-1
	else:
		end_index = string.find(end, start_index)
	if end_index < 0:
		return []
	
	return [start_index, end_index]



func get_next_element(string: String, syntax_type: String, origin_index: int = 0) -> Array:
	match syntax_type:
		"NextLine":
			return get_next_line(string, origin_index)
		"NextBalise":
			return get_next_balise(string, origin_index)
		"NextAttribute":
			return get_next_attribute(string, origin_index)
		_:
			return []



func get_syntax_element_index(string: String, syntax_type: String, element_name: String, origin_index: int = 0) -> Array:
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
			start = ""
			end = "\n"
		"StartOfBalise":
			start = "<"
			end = ""
		"EndOfBalise":
			start = ""
			end = ">"
		"AfterSpace":
			start = " "
			end = ""
		"BeforeSpace":
			start = ""
			end = " "
		"AfterQuote":
			start = "\""
			end = ""
		"BeforeQuote":
			start = ""
			end = "\""
#		"EndOfAttribute":
#		"PrevLine":
#		"PrevBalise":
#		"PrevAttribute":
#
#		"BaliseValue":
#		"AttributeValue":
		
	return get_substr_index(string, [start,end], origin_index)



func get_next_line(string: String, origin_index: int = 0) -> Array:
	origin_index = get_syntax_element_index(string, "EndOfLine", "", origin_index)[1]+1
	origin_index = get_syntax_element_index(string, "StartOfBalise", "", origin_index)[0]
	
	return get_syntax_element_index(string, "EndOfLine", "", origin_index)

func get_next_balise(string: String, origin_index: int = 0) -> Array:
	origin_index = get_syntax_element_index(string, "StartOfBalise", "", origin_index)[0]
	
	return get_syntax_element_index(string, "EndOfBalise", "", origin_index)

func get_next_attribute(string: String, origin_index: int = 0) -> Array:
	if is_inside_balise(string, origin_index):
		origin_index = get_syntax_element_index(string, "AfterSpace", "", origin_index)[0]+1
		var start: int = origin_index
		origin_index = get_syntax_element_index(string, "AfterQuote", "", origin_index)[0]+1
		var end: int = get_syntax_element_index(string, "AfterQuote", "", origin_index)[0]
		return [start,end]
	else:
		origin_index = get_next_balise(string, origin_index)[0]
		return get_next_attribute(string, origin_index)



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
	print(string.substr(bounds[0],bounds[1]+1))

func display_SVG(string: String) -> void:
	print(string)
