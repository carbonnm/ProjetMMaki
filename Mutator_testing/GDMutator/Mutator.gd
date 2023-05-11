extends Control

const MUTATION := {
	"is_equal": {"operator": "==", "type": "relational"},
	"is_not_equal": {"operator": "!=", "type": "relational"},
	"is_bigger_or_equal_than": {"operator": ">=", "type": "relational"},
	"is_smaller_or_equal_than": {"operator": "<=", "type": "relational"},
	"is_bigger_than": {"operator": ">", "type": "relational"},
	"is_smaller_than": {"operator": "<", "type": "relational"},
	"plus": {"operator": "+", "type": "arithmetic"},
	"minus": {"operator": "-", "type": "arithmetic"},
	"multiply": {"operator": "*", "type": "arithmetic"},
	"divide": {"operator": "/", "type": "arithmetic"},
#	"modulo": {"operator": "%", "type": "arithmetic"},
	"equal": {"operator": "=", "type": "assignment"},
	"plus_equal": {"operator": "+=", "type": "assignment"},
	"minus_equal": {"operator": "-=", "type": "assignment"},
	"multiply_equal": {"operator": "*=", "type": "assignment"},
	"divide_equal": {"operator": "/=", "type": "assignment"},
#	"modulo_equal": {"operator": "%=", "type": "assignment"},
}

func _ready():
	get_viewport().files_dropped.connect(on_files_dropped)
#	get_viewport().connect("files_dropped", Callable(self, "on_files_dropped"))


func on_files_dropped(files:PackedStringArray):
	for file in files:
		if file.get_extension() != "gd":
			continue
		
		for _mutation in MUTATION.keys():
			mutate_gd_file(file, _mutation, MUTATION[_mutation]["operator"])


func mutate_gd_file(file: String, mutation_key: String, mutation_value: String):
	var _file = FileAccess.open(file, FileAccess.READ)
	
	var output := ""
	while not _file.eof_reached():
		var line = _file.get_line()
		
		for _mutation in MUTATION.values():
			if ("var" in line or "const" in line or "func" in line) and mutation_value == MUTATION.equal.operator:
				pass
			else:
				if _mutation["type"] == MUTATION[mutation_key]["type"]:
					line.replace(_mutation["operator"], mutation_value)
		
		output += line + "\n"
	
	var filename: String = file.get_file().replace("." + file.get_extension(), "")
	
	var file_output = FileAccess.open(
				"user://" + filename + "_mutation_" + mutation_key
				+ "." + file.get_extension(), FileAccess.WRITE)
	
	file_output.store_string(output)


func _on_open_user_directory_pressed():
	OS.shell_open(ProjectSettings.globalize_path("user://"))
