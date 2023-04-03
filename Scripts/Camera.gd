extends Camera2D

const SCENESIZE = Vector2(1024,600)
const ZOOMMIN = Vector2(0.01,0.01)
const ZOOMMAX = Vector2(1000,1000)

export var zoom_speed = 1.1

signal zoom_changed(spos,szoom)

func update_zoom(event, mouse_position, threshold):
	if zoom > ZOOMMIN && (threshold-ZOOMMIN == Vector2.ZERO):
			zoom_at_point(1/zoom_speed,mouse_position)
	elif zoom < ZOOMMAX && (threshold-ZOOMMAX == Vector2.ZERO):
			zoom_at_point(zoom_speed,mouse_position)
			
func DragCamera(Relative:Vector2):
	position -= Relative
	
	emit_signal("zoom_changed", global_position, zoom)

func zoom_at_point(zoom_change, point):
	var pos0:Vector2 = global_position # camera position
	var viewport0:Vector2 = get_viewport().size # viewport size
	var pos1:Vector2  # next camera position
	var zoom0:Vector2 = zoom # current zoom value
	var zoom1:Vector2 = zoom0 * zoom_change # next zoom value
	
	pos1 = pos0 + (-0.5*viewport0 + point) * (zoom0 - zoom1)
	zoom = zoom1
	global_position = pos1
	
	emit_signal("zoom_changed", global_position, zoom)
