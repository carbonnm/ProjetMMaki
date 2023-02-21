extends Node


onready var _image = $Icon

func _process(delta):
				
	#if Input.is_action_pressed("Copy"):
		#print("copy")
	#elif Input.is_action_pressed("Paste"):
		#print("paste")
	if Input.is_action_pressed("ZoomImage"):
			print("zoom")
			_image.scale.x += 0.05
			_image.scale.y += 0.05
	elif Input.is_action_pressed("DeZoomImage"):
		_image.scale.x -= 0.05
		_image.scale.y -= 0.05
