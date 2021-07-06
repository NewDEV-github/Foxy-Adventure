extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func register_character(character_name:String):
	Globals.add_character(character_name)
