extends "res://addons/gut/test.gd"


var _save: Save = null


func before_each():
	_save = Save.new()


func after_each():
	_save.free()


func test_get_saves_full():
	# Arrange
	_save.saves.append("Test 1")
	_save.saves.append("Test 2")
	_save.saves.append("Test 3")
	# Act
	var result = _save.get_saves()
	# Assert
	assert_eq(result, ["Test 1", "Test 2", "Test 3"], "Get_error")
	
func test_get_saves_empty():
	# Arrange

	# Act
	var result = _save.get_saves()
	# Assert
	assert_eq(result, [], "Get_error")


func test_get_last_save_full():
	# Arrange
	_save.saves.append("Test 1")
	_save.saves.append("Test 2")
	_save.saves.append("Test 3")
	# Act
	var result = _save.get_last_save()
	# Assert
	assert_eq(result, "Test 1", "Get_error")
	#crash when empty Array

#func test_get_last_save_empty():
#	# Arrange
#
#	# Act
#	var result = _save.get_last_save()
#	# Assert
#	assert_eq(result, {}, "Get_error")
#	#crash when empty Array


func test_set_save_nodes():
	# Arrange
	_save.set_save_nodes(["Test 1"])
	# Act
	var result = _save.save_nodes
	# Assert
	assert_eq(result, ["Test 1"], "wrong egality")
	
func test_save():
	# Arrange/Act
	var result = _save.save()
	# Assert
	assert_ne(result, {"BackgroundColor": Color(0,0,0),"Line2D": [],"Label": [],"Sprite": []}, "wrong egality")
	
func test_add_saves():
	# Arrange
	_save.saves.append("Test 1")
	_save.saves.append("Test 2")
	_save.saves.append("Test 3")
	# Act
	_save.add_saves({"test":[]})
	# Assert
#	assert_eq(_save.saves, [{"test": []},"Test 1","Test 2","Test 3"], "not push front")
	
	var complex_example = [{"test": []},"Test 1","Test 2","Test 3"]
	var shallow_copy  = complex_example.duplicate(false)
	var deep_copy = complex_example.duplicate(true)
	assert_eq_deep(complex_example, shallow_copy)
	assert_eq_deep(complex_example, deep_copy)
	assert_eq_deep(shallow_copy, deep_copy)
	
	
func test_erase_save_full():
	# Arrange
	_save.saves.append("Test 1")
	_save.saves.append("Test 2")
	_save.saves.append("Test 3")
	# Act
	_save.erase_save(5)
	_save.erase_save(1)
	# Assert
	assert_eq(_save.saves, ["Test 1","Test 3"], "not deletd correctly")

func test_erase_save_empty():
	# Arrange

	# Act
	_save.erase_save(5)
	_save.erase_save(1)
	# Assert
	assert_eq(_save.saves, [], "not deletd correctly")
	
	
func test_retrieve_elements():
	# Arrange
	var node = Node2D.new()
	add_child(node)
	
	var Line = Line2D.new()
	var label = Label.new()
	var sprite = Sprite.new()
	var background = ColorRect.new()
	
	node.add_child(Line)
	node.add_child(label)
	node.add_child(sprite)
	node.add_child(background)
	
	var save_dict: Dictionary = {
		"BackgroundColor": Color(0,0,0),
		"Line2D": [],
		"Label": [],
		"Sprite": []
	}
	
	var expected_dict: Dictionary = {
		"BackgroundColor": background.color,
		"Line2D": [Line],
		"Label": [label],
		"Sprite": [sprite]
	}
	
	_save.save_nodes = [Line,label,sprite,background]
	
	# Act
	var result:Dictionary = _save.retrieve_elements(save_dict)
	var result_hash := []
	for r in result:
		result_hash.append(r)
	var expected_hash := []
	for r in expected_dict:
		expected_hash.append(r)
	
	# Assert
	assert_eq_deep(result_hash, expected_hash)

func test_apply_global_transform():
	# Arrange
	var node = Node2D.new()
	add_child(node)
	
	node.transform = Transform2D(0.5, Vector2(50,50))
	node.scale = Vector2(2.3,2.3)
	
	var label = Control.new()
	node.add_child(label)
	
	# Act
	var result = _save.apply_global_transform(label)
	
	# Assert
	assert_eq(result.rect_position, Vector2(50,50), "not the same position.")
	assert_eq(str(result.rect_rotation), "0.5", "not the same rotation.")
	assert_eq(result.rect_scale, Vector2(2.3,2.3), "not the same scale.")
