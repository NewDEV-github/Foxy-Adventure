extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	load_dlcs_from_list()

func load_dlcs_from_list():
	DLCLoader.download_dlc_list()
	yield(DLCLoader, "finished_loading_dlcs_cfg")
	for dlc_name in Globals.dlcs:
		print(dlc_name)
		$ItemList.add_item(dlc_name)
