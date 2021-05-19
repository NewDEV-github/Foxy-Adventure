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
	$CanvasLayer/Control/ColorRect/RPGLabel.set_text("Welcome to Foxy Adventure.\nFollow that tutorial to learn controls in the game and much more :3")
	$Timer.start()
	randomize()
	var audio = load(music_files[randi()%music_files.size()])
	$AudioStreamPlayer2D.stream = audio
	$AudioStreamPlayer2D.play()
	Globals.current_stage = 0
#	Fmod.add_listener(0, self)
#	Fmod.play_music_sound_instance("res://assets/Audio/BGM/1stage.ogg", "1stage")
	Globals.save_level(0, Globals.current_save_name)
	add_child(character)
#	character.set_owner(root)
	get_node(str(character.name)).position = startup_position
	get_tree().paused = true

func change_level():
	if Globals.fallen_into_toxins == 0:
		Globals.set_achievement_done("I'm not toxic")
	get_tree().change_scene("res://Scenes/Stages/poziom_2.tscn")
func toxic_entered(body):
	if body.name == "Tails":
		Globals.felt_into_toxine()
		if Globals.new_characters.has(body.name):
			Globals.game_over()


func _on_Node2D_tree_exited():
#	Fmod.stop_sound(Fmod.music_instances["1stage"])
	pass


func _on_Doors_body_entered(body):
	if body.name == "Tails":
		change_level()


func _on_Timer_timeout():
	get_tree().paused = false
	$CanvasLayer/Control/ColorRect/RPGLabel.set_text("Use WASD or Arrow Keys to control your character.")
