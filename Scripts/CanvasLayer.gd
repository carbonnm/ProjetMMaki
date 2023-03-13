extends CanvasLayer

var _tween_active:bool = false
var settings_visible:bool = false

func _on_Button_pressed() -> void:
	if !settings_visible && !_tween_active:
		var tween = get_tree().create_tween()
		tween.tween_property($Panel, "rect_position:x", $Panel.rect_position.x + $Panel.rect_size.x, 0.3)
		settings_visible = true
		
		_tween_active = true
		yield(tween, "finished")
		_tween_active = false
	elif !_tween_active:
		hide_settings_panel()

func hide_settings_panel():
	var tween = get_tree().create_tween()
	tween.tween_property($Panel, "rect_position:x", $Panel.rect_position.x - $Panel.rect_size.x, 0.3)
	settings_visible = false
	
	_tween_active = true
	yield(tween, "finished")
	_tween_active = false

#func _input(event: InputEvent) -> void:
#	if event is InputEventMouseButton:
#		if event.is_pressed():
#			if event.button_index == BUTTON_LEFT:
#				if settings_visible && !_tween_active:
#					var mouse_pos = get_viewport().get_mouse_position()
#					if mouse_pos.x > $Panel.rect_size.x:
#						hide_settings_panel()
