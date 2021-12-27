extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var startup_position = $start_position.position
onready var root = get_tree().root
# Called when the node enters the scene tree for the first time.
var music_files = Globals.stage_music_list
func _ready():
	var character = load(str(Globals.character_path)).instance()
#	ApiScores.force_upload()
	Globals.add_coin(0, true)
	randomize()
#	var audio = load(music_files[randi()%music_files.size()])
	$AudioStreamPlayer2D.stream = Globals.ParseAudioAsStreamData(music_files[randi()%music_files.size()])
	$AudioStreamPlayer2D.play()
	Globals.current_stage = 0
	DiscordSDK.run_rpc(false, true, Globals.get_current_character_name_from_list(), false)
	Globals.save_level(0, Globals.current_save_name)
	add_child(character)
	var game_ui_scene = preload("res://Scenes/game_ui.tscn").instance()
	get_node(str(character.name)).add_child(game_ui_scene)
	get_node(str(character.name)).position = startup_position
	print(Globals.get_current_character_name())
	if character.has_method("set_render_messages_delay"):
		character.set_render_messages_delay(1.5)
	if character.has_method("show_message_box"):
		character.show_message_box(false)
	var msg = ["Strange place...", "I've never been here...","I'd better go..."]
	if character.has_method("render_messages"):
		character.render_messages(msg)
		yield(character, "msg_done")
	if character.has_method("hide_message_box"):
		character.hide_message_box()
#	character.set_owner(root)


func change_level():
	if Globals.fallen_into_toxins == 0:
		Globals.set_achievement_done("I'm clear!")
	get_tree().change_scene(Globals.stage_list[str(int(Globals.get_current_position_in_list_by_path(get_tree().current_scene.filename)) + 1)])
func toxic_entered(body):
	if body.name == Globals.get_current_character_name():
		Globals.felt_into_toxine()
		Globals.game_over()
	


func _on_Node2D_tree_exited():
#	Fmod.stop_sound(Fmod.music_instances["1stage"])
	pass


func _on_Doors_body_entered(body):
	if body.name == Globals.get_current_character_name():
		change_level()


func _on_messagearea_body_entered(body):
	if body.name == Globals.get_current_character_name():
		body.set_render_messages_delay(1.5)
		body.show_message_box(false)
		var msg = ["It looks like there is only one way out of here. Let's go and see what happens next	"]
		body.render_messages(msg)
		yield(body, "msg_done")
		body.hide_message_box()


func _on_AudioStreamPlayer2D_finished():
#	var audio = load(music_files[randi()%music_files.size()])
	$AudioStreamPlayer2D.stream = Globals.ParseAudioAsStreamData(music_files[randi()%music_files.size()])
	$AudioStreamPlayer2D.play()
