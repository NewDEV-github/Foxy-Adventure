
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var sdk
func _ready():
	var _sdk = FoxyAdventureSDK.new()
#	_sdk.init(_sdk.INIT_FLAGS.INIT_DEBUG) #<- test to see what will happen if You don't initialize SDK before calling it's functions
	print(str(_sdk.get_lifes()))

func init_mod():
	sdk = FoxyAdventureSDK.new()
#	sdk.init(sdk.INIT_FLAGS.INIT_DEBUG)
	print(str(sdk.get_lifes()))
	sdk.register_world("Test world", "res://test_scenes/worlds/test_world.tscn")
	sdk.register_character("Test character", "res://test_scenes/characters/test_character.tscn")

"""For more examples, please, take a look at: https://github.com/NewDEV-github/Foxy-Adventure/wiki/SDK"""
