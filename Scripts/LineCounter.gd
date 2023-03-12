extends Label

var Count:String = "0"



func _process(_delta: float) -> void:
	set("custom_colors/font_color", Color(0,0,0))
	set_text(("Number of elements : ") + Count)
	
#stopped working so was replaced with assignation of Count in Main.gd
#func _on_Node2D_Line_count(counter) -> void:
#	print("in line counter")
#	Count = String(counter)
