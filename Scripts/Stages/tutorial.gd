extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var startup_position = $start_position.position
onready var root = get_tree().root
var character = load(str(Globals.character_path)).instance()
# Called when the node enters the scene tree for the first time.
var music_files = ["res://assets/Audio/BGM/1stage2.mp3","res://assets/Audio/BGM/1stage.ogg"]
func _ready():
	set_process(false)
	get_tree().paused = true
	$CanvasLayer/Control/ColorRect/MessageBox.message = "Welcome to Foxy Adventure.\nFollow that tutorial to learn controls in the game and much more :3"
	randomize()
	var audio = load(music_files[randi()%music_files.size()])
	$AudioStreamPlayer2D.stream = audio
	$AudioStreamPlayer2D.play()

func toxic_entered(body):
	if body.name == "Tails":
		Globals.felt_into_toxine()
		if Globals.new_characters.has(body.name):
			Globals.game_over()


func _on_Timer_timeout():
	var prs = false
	Globals.current_stage = 0
#	Fmod.add_listener(0, self)
#	Fmod.play_music_sound_instance("res://assets/Audio/BGM/1stage.ogg", "1stage")
	Globals.save_level(0, Globals.current_save_name)
	add_child(character)
#	character.set_owner(root)
	get_node(str(character.name)).position = startup_position
	get_tree().paused = false
	$Timer.disconnect("timeout", self, "_on_Timer_timeout")
	$CanvasLayer/Control/ColorRect/MessageBox.disconnect("timeout", self, "_on_MessageBox_message_done")
	$CanvasLayer/Control/ColorRect/MessageBox.message = "Use WASD or Arrow Keys to control your character."
	set_process(true)
	
var pressed_1 = false
var pressed_2 = false
func _process(delta):
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		if pressed_1 == false:
			$CanvasLayer/Control/ColorRect/MessageBox.message = "Great!"
			pressed_1 = true
			yield($CanvasLayer/Control/ColorRect/MessageBox,"message_done")
			$Timer.start()
			yield($Timer, "timeout")
			$CanvasLayer/Control/ColorRect/MessageBox.message = "Now press space bar to jump over toxins or between platforms."
			$Timer.start()
			yield($Timer, "timeout")
			pressed_2 = true
	if Input.is_action_pressed("ui_accept") and pressed_2 == true:
		$CanvasLayer/Control/ColorRect/MessageBox.message = "You're ready to go!!"
		$Timer.wait_time = 1.5
		$Timer.start()
		yield($Timer, "timeout")
		BackgroundLoad.get_node("bgload").play_start_transition = true
		BackgroundLoad.get_node("bgload").load_scene("res://Scenes/Stages/poziom_1.tscn")
		$CanvasLayer/Control.hide()
		set_process(false)
		get_node(str(character.name)).queue_free()
func _on_MessageBox_message_done():
	$Timer.start()
