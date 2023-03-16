extends CanvasLayer

var _tween_active:bool = false
var settings_visible:bool = false

var _tween2_active:bool = false
var rightclick_visible:bool = false

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


func _on_RichtClickButton_pressed():
	if !rightclick_visible && !_tween2_active:
		var tween = get_tree().create_tween()
		tween.tween_property($Panel2, "rect_position:x", $Panel2.rect_position.x - $Panel2.rect_size.x, 0.3)
		rightclick_visible = true
		
		_tween2_active = true
		yield(tween, "finished")
		_tween2_active = false
	elif !_tween2_active:
		hide_rightclick_panel()
		

func hide_rightclick_panel():
	var tween = get_tree().create_tween()
	tween.tween_property($Panel2, "rect_position:x", $Panel2.rect_position.x + $Panel2.rect_size.x, 0.3)
	rightclick_visible = false
	
	_tween2_active = true
	yield(tween, "finished")
	_tween2_active = false
