extends Label
#onready var Lines_count = String(get_node("Node2D/Lines").get_child_count())

#onready var _Lines := get_parent().get_child(Lines)

func _process(delta: float) -> void:
	set("custom_colors/font_color", Color(0,0,0))
	#set_text("Number of Line : ") #+ String(Lines_count))
