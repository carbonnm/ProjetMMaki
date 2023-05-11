extends Node

var Utils := preload("res://Scripts/Utilities/Utilities.gd").new()
var TEXTEDIT := preload("res://Classes/Title.gd")

#Creates the new richtextlabel node with the new wanted title
func create_new_title(chosen_title, customization, parent_node):
	#position of the title is the same as the title menu addition 
	#which was set from the retrieved position of the right-click
	parent_node.get_node("CanvasLayer/Titlemenuaddition").visible = false
	
	var textEdit = TEXTEDIT.new()
	var x_pos_title = parent_node.get_node("CanvasLayer/Titlemenuaddition").rect_position.x 
	var y_pos_title = parent_node.get_node("CanvasLayer/Titlemenuaddition").rect_position.y 
	var textEdit_position = Vector2(x_pos_title, y_pos_title)
	parent_node.Utils.get_match_string_node("Elements", parent_node).add_child(textEdit)
	textEdit.set_params(true, str(chosen_title), Vector2(500, 100), textEdit_position)

	
	var type_title = parent_node.get_node("CanvasLayer/Titlemenuaddition").type_title
	var color_title = customization["titlecolor"]
	var title_font = customization["titlefont"]
	var color_subtitle = customization["subtitlecolor"]
	var subtitle_font = customization["subtitlefont"]
	var color_subsubtitle = customization["subsubtitlecolor"]
	var subsubtitle_font = customization["subsubtitlefont"]
	textEdit.ChangeFont(type_title, title_font, color_title, subtitle_font, color_subtitle, subsubtitle_font, color_subsubtitle)
