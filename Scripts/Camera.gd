extends Camera2D

const SCENESIZE = Vector2(1024,600)
const ZOOMMIN = Vector2(0.1,0.1)
const ZOOMMAX = Vector2(10,10)

export var zoom_step = 0.1

signal zoom_changed(spos,szoom)

func _ready() -> void:
	connect("zoom_changed", $"../CanvasLayer/ZoomMenuButton", "display_zoom_value")

func update_zoom(_event, mouse_position, zoom_in : bool):
	if zoom > ZOOMMIN && zoom_in:
			zoom_at_point(-zoom_step,mouse_position)
	elif zoom < ZOOMMAX && !zoom_in:
			zoom_at_point(zoom_step,mouse_position)
			
func DragCamera(Relative:Vector2):
	position -= Relative
	
	emit_signal("zoom_changed", global_position, zoom)

func zoom_at_point(zoom_change, point):
	var pos0:Vector2 = global_position # camera position
	var viewport0:Vector2 = get_viewport().size # viewport size
	var pos1:Vector2  # next camera position
	var zoom0:Vector2 = zoom # current zoom value
	var zoom1:Vector2 = zoom0 + Vector2(zoom_change,zoom_change) # next zoom value
	
	pos1 = pos0 + (-0.5*viewport0 + point) * (zoom0 - zoom1)
	zoom = zoom1
	global_position = pos1
	print("ZOOM : ", zoom)
	
	emit_signal("zoom_changed", global_position, zoom)


