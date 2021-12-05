extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var startup_position = $start_position.position
onready var root = get_tree().root
var character = load(str(Globals.character_path)).instance()
# Called when the node enters the scene tree for the first time.
var music_files = Globals.stage_music_list
func _ready():
	ApiScores.force_upload()
	Globals.add_coin(0, true)
	randomize()
#	var audio = load(music_files[randi()%music_files.size()])
	$AudioStreamPlayer2D.stream = Globals.ParseAudioAsStreamData(music_files[randi()%music_files.size()])
	$AudioStreamPlayer2D.play()
	Globals.current_stage = 2
#	Fmod.add_listener(0, self)
#	Fmod.play_music_sound_instance("res://assets/Audio/BGM/1stage.ogg", "1stage")
	Globals.save_level(2, Globals.current_save_name)
	add_child(character)
#	character.set_owner(root)
	var game_ui_scene = preload("res://Scenes/game_ui.tscn").instance()
	get_node(str(character.name)).add_child(game_ui_scene)
	get_node(str(character.name)).position = startup_position

func change_level():
	get_tree().change_scene(Globals.stage_list[str(int(Globals.get_current_position_in_list_by_path(get_tree().current_scene.filename)) + 1)])
func toxic_entered(body):
	if body.name == Globals.get_current_character_name():
		if Globals.new_characters.has(body.name):
			Globals.game_over()


func _on_Node2D_tree_exited():
#	Fmod.stop_sound(Fmod.music_instances["1stage"])
	pass


func _on_Doors_body_entered(body):
	if body.name == Globals.get_current_character_name():
		change_level()

func _on_AudioStreamPlayer2D_finished():
#	var audio = load(music_files[randi()%music_files.size()])
	$AudioStreamPlayer2D.stream = Globals.ParseAudioAsStreamData(music_files[randi()%music_files.size()])
	$AudioStreamPlayer2D.play()


func _on_messagearea_body_entered(body):
	if body.name == Globals.get_current_character_name():
		body.set_render_messages_delay(1.5)
		body.show_message_box(false)
		var msg = [tr("KEY_CUTSCENE_3_1"), tr("KEY_CUTSCENE_3_2"), tr("KEY_CUTSCENE_3_3")]
		body.render_messages(msg)
		yield(body, "msg_done")
		body.hide_message_box()


func _on_dead_area_body_entered(body):
	if body.name == Globals.get_current_character_name():
		if Globals.new_characters.has(body.name):
			Globals.game_over()

func _on_end_body_entered(body):
	if body.name == Globals.get_current_character_name():
		change_level()
