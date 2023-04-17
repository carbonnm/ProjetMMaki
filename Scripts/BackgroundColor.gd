extends ColorRect


func _ready():
	var _zoom_changed_signal = get_node("../Camera").connect("zoom_changed", self, "UpdateBackground")

func UpdateBackground(global_position, zoom):
	# on prend la pos de la camera ( au centre de la fenetre) et on l'offset en haut à gauche 
#	# Vector2(512,300) car c'est la moitié de la taille interne de l'application
	rect_global_position = global_position - (Vector2(512,300) * zoom) 
	rect_size = Vector2(1024,600) * zoom

