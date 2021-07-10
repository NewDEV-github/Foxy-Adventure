
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sdk = FoxyAdventureSDK.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	sdk.init(sdk.INIT_FLAGS.INIT_DEBUG)
	print(str(sdk.get_lifes()))
func add_stages():
	sdk.register_world("Test world", "res://test_scenes/worlds/test_world.tscn")

func add_characters():
	sdk.register_character("Test character", "res://test_scenes/characters/test_character.tscn")

"""For more examples, please, take a look at: https://github.com/NewDEV-github/Foxy-Adventure/wiki/SDK"""
