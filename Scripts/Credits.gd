extends Node2D


const section_time := 4.0
const line_time := 0.3
const base_speed := 50
const speed_up_multiplier := 10.0

var scroll_speed := base_speed
var speed_up := false

onready var line := $CreditsContainer/LeCredit
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []
var current_image = 0
var last_one 

var credits = [
	[
		"  Credits",
		"",
		"-----------------",
		"------------------",
		""
	],[
		"    Programming",
		"--------------------",
		"",
		"   ABOUTAHER Sofian",
		"",
		"  BARBIEUX Arthur",
		"",
		"   CARBONNELLE Marie",
		"",
		"  GALLOY Manon",
		"",
		"   MICHAUX Manon",
		"",
		"  POLET Simon"
	],[
		"  Art/U.I.",
		"--------------------",
		"",
		"   MICHAUX Manon"
	],[
		"Testers",
		"------------------",
		"",
		"BARBIEUX Arthur",
		"",
		"POLET Simon",
		"",

	],[
		"Tools used",
		"--------------------",
		"",
		"",
		"Developed with:",
		"",
		"",
		" Godot Engine",
		"",
		"",
		"",
		"Art created with:",
		"",
		"",
		" Krita, PixelStudio",
		
	],[
		"Special thanks",
		"------------------------",
		"BERG Lucas for your pull request",
		"'Every member of this team ",
		"",
		"",
		"for having been",
		"",
		"",
		"such wonderful",
		"",
		"",
		"rubber duckies",
		"",
		"",
		"to each other'",
	]
]



func _process(delta):
	var scroll_speed = base_speed * delta
	if visible:
		if section_next:
			section_timer += delta * speed_up_multiplier if speed_up else delta
		
			if section_timer >= section_time:
				section_timer -= section_time
			
				if credits.size() > 0:
					started = true
					section = credits.pop_front()
					curr_line = 0
					add_line()
		
	
		else:
			line_timer += delta * speed_up_multiplier if speed_up else delta
			if line_timer >= line_time:
				line_timer -= line_time
				add_line()
	
		if speed_up:
			scroll_speed *= speed_up_multiplier
	
		if lines.size() > 0:
			for l in lines:
				l.rect_position.y -= scroll_speed
				if l.rect_position.y < -l.get_line_height():
					lines.erase(l)
					l.queue_free()
		
		else:
			if current_image==6:
				finish()


func finish():
	if not finished:
		finished = true
		yield(get_tree().create_timer(1.5), "timeout")
		$CreditsContainer/Dfinal.visible = true
		$CreditsContainer/D6.visible = false
		$CreditsContainer/Grandfinale.play(0.0)
		yield(get_tree().create_timer(5.0), "timeout")
		$CreditsContainer/ButtonSkip.visible = true 
		


func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	
	$CreditsContainer.add_child(new_line)
	
	 
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true
		if current_image<=7:
			if not(current_image == 0) :
				last_one.visible = false
			get_current_image().visible = true
			last_one = get_current_image()
			current_image+=1


func get_current_image():
	if current_image ==0:
		return $CreditsContainer/D1
	if current_image ==1:
		return $CreditsContainer/D2
	if current_image ==2:
		return $CreditsContainer/D3
	if current_image ==3:
		return $CreditsContainer/D4
	if current_image ==4:
		return $CreditsContainer/D5
	if current_image ==5:
		return $CreditsContainer/D6
	if current_image ==6:
		return $CreditsContainer/Dfinal
		
		
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		finish()
	if event.is_action_pressed("ui_down") and !event.is_echo():
		speed_up = true
	if event.is_action_released("ui_down") and !event.is_echo():
		speed_up = false

func _on_Grandfinale_finished():
	$CreditsContainer/Grandfinale.playing=false
	visible = false 


func _on_ButtonSkip_button_up():
	$CreditsContainer/Grandfinale.playing=false
	
	visible = false


func _on_ButtonSkip_mouse_entered():
	$CreditsContainer/dontleavesosoon.visible = true 
