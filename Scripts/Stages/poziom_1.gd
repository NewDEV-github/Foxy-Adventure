extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var startup_position = $start_position.position
onready var root = get_tree().root
var character = load(str(Globals.character_path)).instance()
# Called when the node enters the scene tree for the first time.
func _ready():
	Fmod.add_listener(0, self)
	Fmod.load_file_as_music("res://assets/Audio/BGM/1stage.ogg")
	Globals.fmod_sound = Fmod.create_sound_instance("res://assets/Audio/BGM/1stage.ogg")
	Fmod.play_sound(Globals.fmod_sound)
	Globals.save_level(0, Globals.current_save_name)
	add_child(character)
#	character.set_owner(root)
	get_node(str(character.name)).position = startup_position


func toxic_entered(body):
	var characters = Globals.new_characters
	if characters.has(body.name):
		Globals.game_over()


func _on_Node2D_tree_exited():
	Fmod.stop_sound(Globals.fmod_sound)
