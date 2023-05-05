extends Control

var cam 


onready var zoomLabel = $ZoomText

func _ready() -> void:
	display_zoom_value(null,Vector2(1,1))

func display_zoom_value(__, zoom : Vector2):
	zoomLabel.text = String(round(zoom.x * 100)) + "%"



