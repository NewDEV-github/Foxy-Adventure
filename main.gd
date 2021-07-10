
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sdk = FoxyAdventureSDK.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	sdk.init(sdk.INIT_FLAGS.INIT_DEBUG)
	print(str(sdk.get_lifes()))
	sdk.register_world("Test world", "res://path/to/test/world.tscn")
	sdk.register_character("Test character", "res://path/to/test/character.tscn")

"""For more examples, please, take a look at: https://github.com/NewDEV-github/Foxy-Adventure/wiki/SDK"""
