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
	Globals.add_coin(0, true)
	randomize()
	var audio = load(music_files[randi()%music_files.size()])
	$AudioStreamPlayer2D.stream = audio
	$AudioStreamPlayer2D.play()
	Globals.current_stage = 0
#	Fmod.add_listener(0, self)
#	Fmod.play_music_sound_instance("res://assets/Audio/BGM/1stage.ogg", "1stage")
	Globals.save_level(0, Globals.current_save_name)
	add_child(character)
	get_node(str(character.name)).position = startup_position
	character.set_render_messages_delay(1.5)
	character.show_message_box(false)
	var msg = ["Strange place...", "I've never been there...", "I'd better go..."]
	character.render_messages(msg)
	yield(character, "msg_done")
	character.hide_message_box()
#	character.set_owner(root)


func change_level():
	if Globals.fallen_into_toxins == 0:
		Globals.set_achievement_done("I'm not toxic")
	get_tree().change_scene("res://Scenes/Demo_ThankYou.tscn")
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


func _on_messagearea_body_entered(body):
	if body.name == "Tails":
		body.set_render_messages_delay(1.5)
		body.show_message_box(false)
		var msg = ["It looks like there is only one way out of here.\nLet's go and see what happens next"]
		body.render_messages(msg)
		yield(body, "msg_done")
		body.hide_message_box()


func _on_AudioStreamPlayer2D_finished():
	var audio = load(music_files[randi()%music_files.size()])
	$AudioStreamPlayer2D.stream = audio
	$AudioStreamPlayer2D.play()
