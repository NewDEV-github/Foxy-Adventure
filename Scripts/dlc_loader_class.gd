extends Node
class_name google
var dlc_path = "user://dlcs/"
var dir = Directory.new()
var avaliavble_dlcs
func _ready():
	if not dir.dir_exists("user://dlcs/"):
		dir.open("user://")
		dir.make_dir("dlcs")

func load_all_dlcs():
#	pass
	if dir.open(dlc_path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				if file_name.get_extension() == "pck":
					print("DLC Found")
					ProjectSettings.load_resource_pack(dlc_path + file_name, false)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
