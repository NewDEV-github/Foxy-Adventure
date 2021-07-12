tool
extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var cfg = ConfigFile.new()
var sdk = FoxyAdventureSDK.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	sdk.init(sdk.INIT_FLAGS.INIT_DEBUG)
	$VBoxContainer/version.text = "Version: " + sdk.get_version_string() + " [%s]" % sdk.get_version()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_FoxyAdventureExePath_file_selected(path):
	$VBoxContainer/HBoxContainer/LineEdit.text = path


func _on_LineEdit_text_entered(new_text):
	pass # Replace with function body.


func _on_Button_pressed():
	$FoxyAdventureExePath.popup_centered()

func export_tmp_mod():
	var pck = PCKPacker.new()
	var dir = Directory.new()
	pck.pck_start("user://tmp_mod.pck")
	scan_files_recursive("res://")
#	print(str(scanned_files))
	for i in scanned_files:
		pck.add_file(i, i)
	pck.flush()
	dir.copy("user://tmp_mod.pck", OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/New DEV/Foxy Adventure/Mods/tmp_mod.pck")
	dir.remove("user://tmp_mod.pck")
	var file = File.new()
	var config = ConfigFile.new()
#	print("Exporting MOD to path: " + path)
	var cfg_path = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/New DEV/Foxy Adventure/Mods/"
	var mod_cfg_filename
	if file.file_exists("user://FoxyAdventureModCreator.temp.cfg"):
		file.open("user://FoxyAdventureModCreator.temp.cfg", File.READ)
		mod_cfg_filename = file.get_line()
		file.close()
		config.load("res://" + mod_cfg_filename)
		if not config.has_section_key("mod_info", "pck_files"):
			config.set_value("mod_info", "pck_files", ["tmp_mod.pck"])
		config.save("res://" + mod_cfg_filename)
		print("Copying mod cfg file from %s to %s" % ["res://" + mod_cfg_filename, cfg_path + "/" + mod_cfg_filename])
		dir.copy("res://" + mod_cfg_filename, cfg_path + "/" + mod_cfg_filename)
		dir.remove("user://FoxyAdventureModCreator.temp.cfg")
		
	else:
		OS.alert("Mod configuration file won't be exported.\nPlease fill out all informaiton in \"MOD Info\" tab and click \"Generate .cfg file\", then try again.")

var scanned_files = [""]
func scan_files_recursive(path:String):
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	var av_dirs = [".", "..", ".import", ".git"]
	var av_paths = [".import", ".git", ".", ".."]
	while not file_name == "":
		if dir.current_is_dir() and not av_dirs.has(file_name):
			scan_files_recursive(path + file_name + "/")
		else:
			if not av_paths.has(file_name):
				scanned_files.append(path + file_name)
		file_name = dir.get_next()

func _on_ButtonMOD_pressed():
	export_tmp_mod()
	OS.shell_open($VBoxContainer/HBoxContainer/LineEdit.text + "--test-mod=tmp_mod.pck")
