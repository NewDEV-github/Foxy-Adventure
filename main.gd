
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sdk = FoxyAdventureSDK.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	sdk.init(sdk.INIT_FLAGS.INIT_DEBUG)
	print(str(sdk.get_lifes()))
	sdk.register_world("Test world")
	sdk.register_character("Test character")
