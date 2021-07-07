tool
extends EditorExportPlugin

class_name FoxyAdventureMODCfgExport
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _export_begin(features, is_debug, path, flags):
	var file = File.new()
	var dir = Directory.new()
	var config = ConfigFile.new()
	print("Exporting MOD to path: " + path)
	var cfg_path = path.get_base_dir()
	var mod_cfg_filename
	if file.file_exists("user://FoxyAdventureModCreator.temp.cfg"):
		file.open("user://FoxyAdventureModCreator.temp.cfg", File.READ)
		mod_cfg_filename = file.get_line()
		file.close()
		config.load("res://" + mod_cfg_filename)
		if not config.has_section_key("mod_info", "pck_files"):
			config.set_value("mod_info", "pck_files", [path.get_file()])
		config.save("res://" + mod_cfg_filename)
		print("Copying mod cfg file from %s to %s" % ["res://" + mod_cfg_filename, cfg_path + "/" + mod_cfg_filename])
		dir.copy("res://" + mod_cfg_filename, cfg_path + "/" + mod_cfg_filename)
		
