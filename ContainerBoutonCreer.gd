extends MarginContainer

onready var Cursor = $Litttlearrow

func _on_BoutonCreer_mouse_entered() -> void:
	Cursor.visible = true

func _on_BoutonCreer_mouse_exited() -> void:
	Cursor.visible = false
