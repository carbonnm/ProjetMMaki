extends Node2D

export var mainScene : PackedScene


func _on_CreateButton_button_up():
	get_tree().change_scene("res://Main.tscn")