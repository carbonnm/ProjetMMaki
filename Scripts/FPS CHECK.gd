extends Label

func _process(_delta: float) -> void:
	set("custom_colors/font_color", Color(0,0,0))
	set_text("FPS " + String(Engine.get_frames_per_second()))
