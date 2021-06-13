tool
extends EditorExportPlugin

class_name TranslationsExport
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _export_begin(features, is_debug, path, flags):
	if 'translations' in features:
		var dir = Directory.new()
		var pck = PCKPacker.new()
		var base_path = path.get_base_dir()
		if dir.dir_exists(base_path + '/translations/'):
			dir.remove(base_path + '/translations/')
			dir.make_dir(base_path + '/translations/')
		else:
			dir.make_dir(base_path + '/translations/')
		if dir.open("res://translations/") == OK:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if dir.current_is_dir():
					print("Found directory: " + file_name)
				else:
					if file_name.get_extension() == "translation":
						pck.pck_start(base_path + '/translations/' + file_name.get_file() + ".pck")
						pck.add_file('res://translations/' + file_name.get_file(), 'res://translations/' + file_name.get_file())
						pck.flush()
				file_name = dir.get_next()
