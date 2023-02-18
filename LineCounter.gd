extends Label

var Count:String = "0"

func _process(delta: float) -> void:
	set("custom_colors/font_color", Color(0,0,0))
	set_text(("Number of Line : ") + Count)

func _on_Node2D_Line_count(counter) -> void:
	Count = String(counter)
