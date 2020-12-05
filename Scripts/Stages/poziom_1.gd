extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var startup_position = $start_position.position
onready var root = get_tree().root
var character = load(str(Globals.character_path)).instance()
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.save_level(0, Globals.current_save_name)
	add_child(character)
#	character.set_owner(root)
	get_node(str(character.name)).position = startup_position


func toxic_entered(body):
	var characters = Globals.new_characters
	if characters.has(body.name):
		Globals.game_over()
