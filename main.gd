
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var sdk
var worlds = {
	"Pixel Adventure": "res://scenes/stages/pixel_adventure/stage.tscn",
	"Pixel Adventure 2": "res://scenes/stages/pixel_adventure/stage2.tscn",
	"Ice Cap Adventure": "res://scenes/stages/ice_cap_adventure/ice_01.tscn",
	"Ice Cap Adventure 2": "res://scenes/stages/ice_cap_adventure/ice_02.tscn",
	"Ice Cap Adventure 3": "res://scenes/stages/ice_cap_adventure/ice_03.tscn",
	"Jungle Ruins": "res://scenes/stages/jungle_ruins/jungle_ruins01.tscn",
	"Jungle Ruins 2": "res://scenes/stages/jungle_ruins/jungle_ruins02.tscn",
	"Jungle Ruins 3": "res://scenes/stages/jungle_ruins/jungle_ruins03.tscn",
	"Hill": "res://scenes/stages/hill/hill_1.tscn",
	"Hill 2": "res://scenes/stages/hill/hill_2.tscn",
	"Hill 3": "res://scenes/stages/hill/hill_3.tscn",
	"CastleMania": "res://scenes/stages/castle_mania/castle_mania01.tscn",
	"CastleMania 2": "res://scenes/stages/castle_mania/castle_mania02.tscn",
	"CastleMania 3": "res://scenes/stages/castle_mania/castle_mania03.tscn",
	"Sci-Fi": "res://scenes/stages/scifi/sci_fi_1.tscn",
	"Sci-Fi 2": "res://scenes/stages/scifi/sci_fi_2.tscn",
	"Sci-Fi 3": "res://scenes/stages/scifi/sci_fi_3.tscn",
}
var characters = {
	"Robi": "res://scenes/robi.tscn",
	"Ufo Robi": "res://scenes/ufo_robi.tscn",
}
func init_mod():
	sdk = FoxyAdventureSDK.new()
	sdk.init(sdk.INIT_FLAGS.INIT_DEBUG)
	print(str(sdk.get_lifes()))
	for i in worlds:
		sdk.register_world(i, worlds[i])
	for i in characters:
		sdk.register_character(i, characters[i])
	sdk.run_rpc("Testing modification RPC Support", "MOD SUPPORT")

"""For more examples, please, take a look at: https://github.com/NewDEV-github/Foxy-Adventure/wiki/SDK"""
