extends "res://addons/gut/test.gd"

var Save := load("res://SavePlugin/SVGSyntax.gd")
var _save = null

func before_each():
	_save = Save.new()

func after_each():
	_save.free()

func test_get_svg_image():
	# Arrange/Act
	var result: Dictionary = _save.get_svg_image(Vector2.ZERO, Vector2(1,1), "res://4ImagesChoix/Architecture/architecture1.png")
	# Assert
	assert_eq(result["name"], "image", "Invalid name value.")
	assert_eq(result["attributes"]["x"], 0.0, "Invalid x value.")
	assert_eq(result["attributes"]["y"], 0.0, "Invalid y value.")
	assert_eq(result["attributes"]["width"], 1.0, "Invalid width value.")
	assert_eq(result["attributes"]["height"], 1.0, "Invalid height value.")
	assert_eq(result["attributes"]["href"], "res://4ImagesChoix/Architecture/architecture1.png", "Invalid href value.")
	assert_eq(result["children"], [], "Invalid children value.")

func test_get_svg_text():
	# Arrange/Act
	var result: Dictionary = _save.get_svg_text("my_test_label", Vector2(1,1), 15, "Monolitic Bold", Color(15.0,15.3,0.0,17), -17.6)
	#Assert
	assert_eq(result["name"], "text", "Invalid name value.")
	assert_eq(result["attributes"]["x"], 1.0, "Invalid x value.")
	assert_eq(result["attributes"]["y"], 1.0, "Invalid y value.")
	assert_eq(result["attributes"]["font-size"], 15, "Invalid font-size value.")
	assert_eq(result["attributes"]["font-family"], "Monolitic Bold", "Invalid font-family value.")
	assert_eq(result["attributes"]["fill"], "#" + str(Color(15.0,15.3,0.0).to_html().substr(2)), "Invalid fill value.")
	assert_eq(result["attributes"]["text-anchor"], "middle", "Invalid text-anchor value.")
	assert_eq(result["attributes"]["dominant-baseline"], "middle", "Invalid dominant-baseline value.")
	assert_eq(result["label"], "my_test_label", "Invalid label value.")
	assert_eq(result["children"], [], "Invalid children value.")

func test_get_svg_path():
	# Arrange
	var pool_vector2_array := PoolVector2Array()
	var vector1: Vector2 = Vector2(randf(), randf())
	var vector2: Vector2 = Vector2(randf(), randf())
	var vector3: Vector2 = Vector2(randf(), randf())
	pool_vector2_array.append(vector1)
	pool_vector2_array.append(vector2)
	pool_vector2_array.append(vector3)
	# Act
	var result: Dictionary = _save.get_svg_path(pool_vector2_array,  Color(15.0,15.3,0.0,17), 14)
	# Assert
	var expected_d_result: String = "M " + str(vector1.x) + "," + str(vector1.y)
	expected_d_result +=  " L " + str(vector2.x) + "," + str(vector2.y) + " "
	expected_d_result += str(vector3.x) + "," + str(vector3.y)
	assert_eq(result["name"], "path", "Invalid name value.")
	assert_eq(result["attributes"]["d"], expected_d_result, "Invalid d value.")
	assert_eq(result["attributes"]["stroke"], "#" + str(Color(15.0,15.3,0.0).to_html().substr(2)), "Invalid stroke value.")
	assert_eq(result["attributes"]["stroke-width"], 14, "Invalid stroke-width value.")
	assert_eq(result["attributes"]["fill"], "none", "Invalid fill value.")
	assert_eq(result["children"], [], "Invalid children value.")

func test_get_svg_rect():
	# Arrange/Act
	var result: Dictionary = _save.get_svg_rect(Vector2.ZERO, Vector2(1,1), Color(15.0,15.3,0.0,17))
	# Assert
	assert_eq(result["name"], "rect", "Invalid name value.")
	assert_eq(result["attributes"]["x"], 0.0, "Invalid x value.")
	assert_eq(result["attributes"]["y"], 0.0, "Invalid y value.")
	assert_eq(result["attributes"]["width"], 1.0, "Invalid width value.")
	assert_eq(result["attributes"]["height"], 1.0, "Invalid height value.")
	assert_eq(result["attributes"]["fill"], "#" + str(Color(15.0,15.3,0.0).to_html().substr(2)), "Invalid fill value.")
	assert_eq(result["children"], [], "Invalid children value.")

func test_svg_style():
	# Arrange/Act
	var result: Dictionary = _save.get_svg_style("my-custom-font-family-path")
	# Assert
	assert_eq(result["name"], "style", "Invalid name value.")
	assert_eq(result["attributes"].size(), 0, "Invalid attributes value.")
	var regex := RegEx.new()
	var _ok: bool = regex.compile(".*@font-face {.*\n*.*font-family: \"custom-font-family\";.*\n*.*src: url.\"my-custom-font-family-path\".;.*\n*.*}")
	assert_not_null(regex.search(result["label"]), "Invalid label value")
	assert_eq(result["children"], [], "Invalid children value.")

func test_get_defs():
	# Arrange/Act
	var result: Dictionary = _save.get_defs()
	# Assert
	assert_eq(result["name"], "defs", "Invalid name value.")
	assert_eq(result["attributes"].size(), 0, "Invalid attributes value.")
	assert_eq(result["children"], [], "Invalid children value.")

func test_get_svg():
	# Arrange/Act
	var result: Dictionary = _save.get_svg(Vector2(0.1,0.1), Vector2(1.1,1.1), {"name": "defs", "attributes": {}, "children": []})
	# Assert
	assert_eq(result["name"], "svg", "Invalid name value.")
	assert_eq(result["attributes"]["viewBox"], "0.1 0.1 1.1 1.1", "Invalid viewBox value.")
	assert_eq(result["attributes"]["xmlns"], "http://www.w3.org/2000/svg", "Invalid xmlns value.")
	assert_eq(result["defs"]["name"], "defs", "Invalid defs name value.")
	assert_eq(result["defs"]["attributes"].size(), 0, "Invalid defs attributes value.")
	assert_eq(result["defs"]["children"], [], "Invalid defs children value.")
	assert_eq(result["children"], [], "Invalid children value.")

func test_get_syntax():
	# Arrange/Act
	var svg_block: Dictionary = {"name": "svg", "attributes": {"viewBox": "0 0 1 1", "xmlns": "http://www.w3.org/2000/svg"}, "defs": {}, "children": []}
	var result: Dictionary = _save.get_syntax(svg_block)
	# Assert
	assert_eq(result["xml"], "<?xml version=\"1.0\" encoding=\"UTF-8\"?>", "Invalid xml value.")
	assert_eq(result["doctype"], "<!DOCTYPE svg>", "Invalid doctype value.")
	assert_eq(result["svg"]["name"], "svg", "Invalid svg value.")


func test_PoolVector2Array_to_d_path_with_empty():
	# Arrange
	var pool_vector2_array := PoolVector2Array()
	# Act
	var result: String = _save.PoolVector2Array_to_d_path(pool_vector2_array)
	# Assert
	assert_eq(result, "", "Non-empty string returned.")

func test_PoolVector2Array_to_d_path_with_one_element():
	# Arrange
	var pool_vector2_array := PoolVector2Array()
	var vector: Vector2 = Vector2(randf(), randf())
	pool_vector2_array.append(vector)
	# Act
	var result: String = _save.PoolVector2Array_to_d_path(pool_vector2_array)
	# Assert
	assert_eq(result, "M " + str(vector.x) + "," + str(vector.y), "Invalid one element string returned.")

func test_PoolVector2Array_to_d_path_with_multiple_elements():
	# Arrange
	var pool_vector2_array := PoolVector2Array()
	var vector1: Vector2 = Vector2(randf(), randf())
	var vector2: Vector2 = Vector2(randf(), randf())
	var vector3: Vector2 = Vector2(randf(), randf())
	pool_vector2_array.append(vector1)
	pool_vector2_array.append(vector2)
	pool_vector2_array.append(vector3)
	# Act
	var result: String = _save.PoolVector2Array_to_d_path(pool_vector2_array)
	# Assert
	var expected_result: String = "M " + str(vector1.x) + "," + str(vector1.y)
	expected_result +=  " L " + str(vector2.x) + "," + str(vector2.y) + " "
	expected_result += str(vector3.x) + "," + str(vector3.y)
	assert_eq(result, expected_result, "Invalid multiple elements string returned.")

func test_get_style_label():
	# Arrange/Act
	var result: String = _save.get_style_label("my-custom-font-family-name", "my-custom-font-family-path")
	# Assert
	var regex := RegEx.new()
	var _ok: bool = regex.compile(".*@font-face {.*\n*.*font-family: \"my-custom-font-family-name\";.*\n*.*src: url.\"my-custom-font-family-path\".;.*\n*.*}")
	assert_not_null(regex.search(result), "Invalid string returned.")

func test_add_svg_child():
	# Arrange
	var parent: Dictionary = {"name": "svg", "attributes": {"viewBox": "0 0 1 1", "xmlns": "http://www.w3.org/2000/svg"}, "defs": {}, "children": []}
	var child: Dictionary = {"name": "path", "attributes": {"d": "M 12.25,255 L 546 35.2 22 24.1", "stroke": "black", "stroke-width": 12, "fill": "none"}, "children": []}
	# Act
	var result: Dictionary = _save.add_svg_child(parent, child)
	# Assert
	assert_eq(result["children"][0]["name"], "path", "Incorrect child.")
	assert_eq(result["children"].size(), 1, "Incorrect number of childs.")

func test_get_balise_attributes_string():
	# Arrange
	var balise: Dictionary = {"name": "svg", "attributes": {"viewBox": "0 0 1 1", "xmlns": "http://www.w3.org/2000/svg"}, "defs": {}, "children": []}
	# Act
	var result: String = _save.get_balise_attributes_string(balise)
	# Assert
	assert_eq(result, "viewBox=\"0 0 1 1\" xmlns=\"http://www.w3.org/2000/svg\"", "Invalid attribute string.")

func test_get_balise_string():
	# Arrange
	var balise: Dictionary = {"name": "text","attributes": {"x": 0,"y": 0,"font-size": 12,"font-family": "custom-font-family","fill": "black","text-anchor": "middle","dominant-baseline": "middle","transform": "rotate(0 0 0)"},"label": "my_label","children": []}
	# Act
	var result: String = _save.get_balise_string(balise)
	# Assert
	assert_eq(result, "<text x=\"0\" y=\"0\" font-size=\"12\" font-family=\"custom-font-family\" fill=\"black\" text-anchor=\"middle\" dominant-baseline=\"middle\" transform=\"rotate(0 0 0)\">my_label</text>", "Invalid balise string.")

func test_get_balise_block_string():
	# Arrange
	var balise: Dictionary = {"name": "svg", "attributes": {"viewBox": "0 0 1 1", "xmlns": "http://www.w3.org/2000/svg"}, "defs": {}, "children": [{"name": "text","attributes": {"x": 0,"y": 0,"font-size": 12,"font-family": "custom-font-family","fill": "black","text-anchor": "middle","dominant-baseline": "middle","transform": "rotate(0 0 0)"},"label": "my_label","children": []}]}
	# Act
	var result: String = _save.get_balise_block_string(balise)
	# Assert
	assert_eq(result, "<svg viewBox=\"0 0 1 1\" xmlns=\"http://www.w3.org/2000/svg\">\n\n\t<text x=\"0\" y=\"0\" font-size=\"12\" font-family=\"custom-font-family\" fill=\"black\" text-anchor=\"middle\" dominant-baseline=\"middle\" transform=\"rotate(0 0 0)\">my_label</text>\n\n</svg>")

func test_get_svg_string():
	# Arrange
	var path: Dictionary = {"name": "path","attributes": {"d": "M 12.1,12 L 1,1 18,13.2","stroke": "black","stroke-width": 12,"fill": "none"},"children": []}
	var text: Dictionary = {"name": "text","attributes": {"x": 0,"y": 0,"font-size": 12,"font-family": "custom-font-family","fill": "black","text-anchor": "middle","dominant-baseline": "middle","transform": "rotate(0 0 0)"},"label": "my_label","children": []}
	var svg: Dictionary = {"name": "svg","attributes": {"viewBox": "0 0 1 1","xmlns": "http://www.w3.org/2000/svg"},"defs": {},"children": [path, text]}
	var syntax: Dictionary = {"xml": "<?xml version=\"1.0\" encoding=\"UTF-8\"?>","doctype": "<!DOCTYPE svg>","svg": svg}
	# Act
	var result: String = _save.get_svg_string(syntax)
	print(result)
	# Assert
	var expected_result: String = "<?xml version=\"1.0\" encoding=\"UTF-8\".>.*\n.*"
	expected_result += "<!DOCTYPE svg>.*\n.*"
	expected_result += "<svg viewBox=\"0 0 1 1\" xmlns=\"http://www.w3.org/2000/svg\">.*\n\n.*"
	expected_result += "<path d=\"M 12.1,12 L 1,1 18,13.2\" stroke=\"black\" stroke-width=\"12\" fill=\"none\"></path>.*\n\n.*"
	expected_result += "<text x=\"0\" y=\"0\" font-size=\"12\" font-family=\"custom-font-family\" fill=\"black\" text-anchor=\"middle\" dominant-baseline=\"middle\" transform=\"rotate.0 0 0.\">my_label</text>.*\n\n.*"
	expected_result += "</svg>"
	var regex := RegEx.new()
	var _ok: bool = regex.compile(expected_result)
	assert_not_null(regex.search(result), "Invalid string returned.")




















