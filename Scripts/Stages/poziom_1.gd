extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var startup_position = $start_position.position
onready var root = get_tree().root
var character = load(str(Globals.character_path)).instance()
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.current_stage = 0
#	Fmod.add_listener(0, self)
#	Fmod.play_music_sound_instance("res://assets/Audio/BGM/1stage.ogg", "1stage")
	Globals.save_level(0, Globals.current_save_name)
	add_child(character)
#	character.set_owner(root)
	get_node(str(character.name)).position = startup_position


func toxic_entered(body):
	if Globals.new_characters.has(body.name):
		Globals.game_over()


func _on_Node2D_tree_exited():
#	Fmod.stop_sound(Fmod.music_instances["1stage"])
	pass
