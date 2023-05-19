extends GutTest

const SCENE_PATH := "res://Scene/Canvas.tscn"
var Scene := load(SCENE_PATH)
var _canvas: Node2D = null
var viewport: Viewport = null

var rng: RandomNumberGenerator = null
var _seed: int = 0
var event_sequence: Array = []

var mouse_position: Vector2 = Vector2(512,300)

enum kind_of_event {
	One_Shot_Event = 22,
	Process_Event = 2,
	Jail_Event = 1,
	Random_Key_Event = 2
}

enum one_shot_event {
	Key_Space,
	Key_D,
	Key_F,
	Key_G,
	Key_R,
	Key_S,
	Key_Z,
	Key_Bksp,
	Key_Del,
	Key_Left,
	Key_Up,
	Key_Right,
	Key_Down,
	
	Macro_Ctrl_Plus,
	Macro_Ctrl_Minus,
	Macro_Ctrl_C,
	Macro_Ctrl_V,
	Macro_Ctrl_Y,
	Macro_Ctrl_Z,
	
	Mouse_Roll_Up,
	Mouse_Roll_Down
}

enum process_event {
	Mouse_Button_Left,
	Mouse_Button_Middle
}

enum jail_event {
	Macro_Ctrl_S
}

func before_all():
	_canvas = Scene.instance()
	viewport = Viewport.new()
	viewport.size = Vector2(1024,600)
	viewport.add_child(_canvas)
	self.add_child(viewport)
	
	set_rng()

func after_all():
	viewport.queue_free()
	self.queue_free()

func test_fuzzing():
	var seed_file: File = File.new()
	var opened: int = seed_file.open("res://GUT/Log/event_sequence.txt", File.WRITE)
	if opened != 0:
		print("Error on file opening.")
	else:
		var string_to_store = "SEED : " + str(_seed) + "\n\n"
	
		seed_file.store_string(string_to_store)
		seed_file.close()
	
		
	create_random_event()
	
	
	for _i in range(1000000):
		# Arrange
		var event = create_random_event()
		
		# Act
		if event != null:
			_canvas._input(event)
		
		_canvas._physics_process(rng.randf_range(0.0,1.0))
	
	# Assert
	var log_file: File = File.new()
	opened = log_file.open("res://GUT/Log/event_sequence.txt", File.WRITE)
	if opened != 0:
		print("Error on file opening.")
	else:
		var string_to_store = "SEED : " + str(_seed) + "\n\n"
		var k: int = 1
		event_sequence = event_sequence.slice(-100,event_sequence.size()-1)
		for element in event_sequence:
				
			string_to_store += str(element)
			
			if k % 10 == 0:
				string_to_store += "\n -> "
			else:
				string_to_store += " -> "
				
			k += 1
		
		string_to_store.rstrip(4)
				
		log_file.store_string(string_to_store)
		log_file.close()

func create_random_event():
	var kind_of_event_total_weight: int = kind_of_event.One_Shot_Event + kind_of_event.Process_Event + kind_of_event.Jail_Event + kind_of_event.Random_Key_Event
		
	var random_kind_of_event: int = rng.randi_range(1,kind_of_event_total_weight)
	
	if random_kind_of_event <= kind_of_event.One_Shot_Event:
		kind_of_event.One_Shot_Event = 22
		kind_of_event.Process_Event = 2
		kind_of_event.Jail_Event = 1
		kind_of_event.Random_Key_Event = 2
		return get_random_one_shot_event()
	
	elif random_kind_of_event <= kind_of_event.Process_Event + kind_of_event.One_Shot_Event:
		if kind_of_event.Process_Event >= 25:
			kind_of_event.Process_Event -= 25
		if kind_of_event.Process_Event == 2:
			kind_of_event.Process_Event = 425
		return get_random_process_event()
	
	elif random_kind_of_event <= kind_of_event.Jail_Event + kind_of_event.Process_Event + kind_of_event.One_Shot_Event:
		if kind_of_event.Random_Key_Event > 48:
			kind_of_event.Random_Key_Event -= 48
		if kind_of_event.Random_Key_Event == 3:
			kind_of_event.Jail_Event = 48
			kind_of_event.Random_Key_Event = 408
		return get_jail_event()
	
	else:
		return get_random_key_event()

func get_random_one_shot_event():
	var random_event: int = rng.randi_range(0,21)
	
	match random_event:
		one_shot_event.Key_Space:
			event_sequence.append(OS.get_scancode_string(KEY_SPACE))
			return InputFactory.key_down(KEY_SPACE)
		one_shot_event.Key_D:
			event_sequence.append(OS.get_scancode_string(KEY_D))
			return InputFactory.key_down(KEY_D)
		one_shot_event.Key_F:
			event_sequence.append(OS.get_scancode_string(KEY_F))
			return InputFactory.key_down(KEY_F)
		one_shot_event.Key_G:
			event_sequence.append(OS.get_scancode_string(KEY_G))
			return InputFactory.key_down(KEY_G)
		one_shot_event.Key_R:
			event_sequence.append(OS.get_scancode_string(KEY_R))
			return InputFactory.key_down(KEY_R)
		one_shot_event.Key_S:
			event_sequence.append(OS.get_scancode_string(KEY_S))
			return InputFactory.key_down(KEY_S)
		one_shot_event.Key_Z:
			event_sequence.append(OS.get_scancode_string(KEY_Z))
			return InputFactory.key_down(KEY_Z)
		one_shot_event.Key_Bksp:
			event_sequence.append(OS.get_scancode_string(KEY_BACKSPACE))
			return InputFactory.key_down(KEY_BACKSPACE)
		one_shot_event.Key_Del:
			event_sequence.append(OS.get_scancode_string(KEY_DELETE))
			return InputFactory.key_down(KEY_DELETE)
		one_shot_event.Key_Left:
			event_sequence.append(OS.get_scancode_string(KEY_LEFT))
			return InputFactory.key_down(KEY_LEFT)
		one_shot_event.Key_Up:
			event_sequence.append(OS.get_scancode_string(KEY_UP))
			return InputFactory.key_down(KEY_UP)
		one_shot_event.Key_Right:
			event_sequence.append(OS.get_scancode_string(KEY_RIGHT))
			return InputFactory.key_down(KEY_RIGHT)
		one_shot_event.Key_Down:
			event_sequence.append(OS.get_scancode_string(KEY_DOWN))
			return InputFactory.key_down(KEY_DOWN)
			
		one_shot_event.Macro_Ctrl_Plus:
			event_sequence.append(OS.get_scancode_string(KEY_MASK_CTRL) + OS.get_scancode_string(KEY_PLUS))
			Input.action_press("Zoom")
			Input.action_release("Zoom")
			return null
		one_shot_event.Macro_Ctrl_Minus:
			event_sequence.append(OS.get_scancode_string(KEY_MASK_CTRL) + OS.get_scancode_string(KEY_MINUS))
			Input.action_press("Unzoom")
			Input.action_release("Unzoom")
			return null
		one_shot_event.Macro_Ctrl_C:
			event_sequence.append(OS.get_scancode_string(KEY_MASK_CTRL) + OS.get_scancode_string(KEY_C))
			Input.action_press("Copy")
			Input.action_release("Copy")
			return null
		one_shot_event.Macro_Ctrl_V:
			event_sequence.append(OS.get_scancode_string(KEY_MASK_CTRL) + OS.get_scancode_string(KEY_V))
			Input.action_press("Paste")
			Input.action_release("Paste")
			return null
		one_shot_event.Macro_Ctrl_Y:
			event_sequence.append(OS.get_scancode_string(KEY_MASK_CTRL) + OS.get_scancode_string(KEY_Y))
			Input.action_press("Redo")
			Input.action_release("Redo")
			return null
		one_shot_event.Macro_Ctrl_Z:
			event_sequence.append(OS.get_scancode_string(KEY_MASK_CTRL) + OS.get_scancode_string(KEY_Z))
			Input.action_press("Undo")
			Input.action_release("Undo")
			return null
		
		one_shot_event.Mouse_Roll_Up:
			event_sequence.append("Wheel Up")
			return InputFactory.new_mouse_button_event(mouse_position,mouse_position,true,BUTTON_WHEEL_UP)
		one_shot_event.Mouse_Roll_Down:
			event_sequence.append("Wheel Down")
			return InputFactory.new_mouse_button_event(mouse_position,mouse_position,true,BUTTON_WHEEL_DOWN)

func get_random_process_event():
	var random_event: int = rng.randi_range(0,1)
	jittler_mouse_position()
	
	match random_event:
		process_event.Mouse_Button_Left:
			event_sequence.append("Button Left" + " " + str(mouse_position))
			return InputFactory.new_mouse_button_event(mouse_position,mouse_position,true,BUTTON_LEFT)
		process_event.Mouse_Button_Middle:
			event_sequence.append("Button Middle" + " " + str(mouse_position))
			return InputFactory.new_mouse_button_event(mouse_position,mouse_position,true,BUTTON_MIDDLE)

func get_jail_event():
	var random: int = rng.randi_range(0,1)
	
	if random == 1:
		event_sequence.append("Enter")
		return InputFactory.key_down(KEY_ENTER)
	
	else:
		event_sequence.append(OS.get_scancode_string(KEY_MASK_CTRL) + OS.get_scancode_string(KEY_S))
		Input.action_press("SVGSave")
		Input.action_release("SVGSave")
		return null

func get_random_key_event():
	var random_key: int = rng.randi_range(0,255)
	event_sequence.append(OS.get_scancode_string(random_key))
	return InputFactory.key_down(random_key)

func jittler_mouse_position():
	mouse_position += Vector2(rng.randf_range(0.0,1.0), rng.randf_range(0.0,1.0))

func set_rng():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	_seed = rng.get_seed()
	
