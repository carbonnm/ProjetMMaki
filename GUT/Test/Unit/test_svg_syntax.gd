extends "res://addons/gut/test.gd"

var Save := load("res://SavePlugin/SVGSyntax.gd")
var _save = null

func before_each():
	_save = Save.new()

func after_each():
	_save.free()

func test_get_svg_image():
	var result: Dictionary = _save.get_svg_image(Vector2.ZERO, Vector2(1,1), "res://4ImagesChoix/Architecture/architecture1.png")
	assert_eq(result["name"], "image", "Invalid name value.")
	assert_eq(result["attributes"]["x"], 0.0, "Invalid x value.")
	assert_eq(result["attributes"]["y"], 0.0, "Invalid y value.")
	assert_eq(result["attributes"]["width"], 1.0, "Invalid width value.")
	assert_eq(result["attributes"]["height"], 1.0, "Invalid height value.")
	assert_eq(result["attributes"]["href"], "res://4ImagesChoix/Architecture/architecture1.png", "Invalid href value.")
	assert_eq(result["children"], [], "Invalid children value.")

func test_get_svg_text():
	var result: Dictionary = _save.get_svg_text("my_test_label", Vector2(1,1), 15, "Monolitic Bold", Color(15.0,15.3,0.0,17), -17.6)
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

func test_PoolVector2Array_to_d_path_with_empty():
	var pool_vector2_array := PoolVector2Array()
	var result: String = _save.PoolVector2Array_to_d_path(pool_vector2_array)
	assert_eq(result, "", "Non-empty string returned.")

func test_PoolVector2Array_to_d_path_with_one_element():
	var pool_vector2_array := PoolVector2Array()
	var vector: Vector2 = Vector2(randf(), randf())
	pool_vector2_array.append(vector)
	var result: String = _save.PoolVector2Array_to_d_path(pool_vector2_array)
	assert_eq(result, "M " + str(vector.x) + "," + str(vector.y), "Invalid one element string returned.")

func test_PoolVector2Array_to_d_path_with_multiple_elements():
	var pool_vector2_array := PoolVector2Array()
	var vector1: Vector2 = Vector2(randf(), randf())
	var vector2: Vector2 = Vector2(randf(), randf())
	var vector3: Vector2 = Vector2(randf(), randf())
	pool_vector2_array.append(vector1)
	pool_vector2_array.append(vector2)
	pool_vector2_array.append(vector3)
	var result: String = _save.PoolVector2Array_to_d_path(pool_vector2_array)
	var expected_result: String = "M " + str(vector1.x) + "," + str(vector1.y)
	expected_result +=  " L " + str(vector2.x) + "," + str(vector2.y) + " "
	expected_result += str(vector3.x) + "," + str(vector3.y)
	assert_eq(result, expected_result, "Invalid multiple elements string returned.")


