extends VBoxContainer

var color := Color.white
var color_picker = false

func _ready() -> void:
	color = $Color.color

func _on_Color_color_changed(_color: Color) -> void:
	color = _color
