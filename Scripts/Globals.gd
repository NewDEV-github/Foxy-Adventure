extends Node
var bits = 32
var stage_list = {
	"0": "res://Scenes/Stages/poziom_1.tscn",
	"1": "res://Scenes/Stages/poziom_2.tscn",
	"2": "res://Scenes/Stages/poziom_3.tscn",
	"3": "res://Scenes/Stages/poziom_4.tscn",
	"4": "res://Scenes/Stages/poziom_5.tscn",
	"5": "res://Scenes/Stages/poziom_6.tscn",
	"6": "res://Scenes/Stages/poziom_7.tscn",
	"7": "res://Scenes/Stages/poziom_8.tscn",
	"8": "res://Scenes/Stages/poziom_9.tscn",
	"9": "res://Scenes/Stages/poziom_10.tscn",
	"10": "res://Scenes/Stages/poziom_11.tscn",
	"11": "res://Scenes/Stages/poziom_12.tscn",
	"12": "res://Scenes/Stages/poziom_13.tscn",
	"13": "res://Scenes/Stages/poziom_14.tscn",
	"14": "res://Scenes/Stages/poziom_15.tscn",
}
#var feedback_script = preload("res://FeedBack/Main.gd").new()
signal debugModeSet
signal loaded
signal minimap
signal nsfw
var install_base_path = OS.get_executable_path().get_base_dir() + "/"
var minimap_enabled = true setget set_minimap_enabled, get_minimap_enabled
var debugMode = false
var coming_from_house = ''
var object_transparency = 0.65
var selected_character
var character_path
var world
var release_mode = false
var game_hour = 10 #seconds
var window_x_resolution = 1024
var window_y_resolution = 600
var character_position
var last_world_position = Vector2(0,0)
var cfile = ConfigFile.new()
var file =  File.new()
var version_string:String = "alpha"
var version_commit:String = "unknown"
var current_save_name = ""
var new_characters:Array = [
	"NewTheFox",
	"Tails",
]
func construct_game_version():
	var text = "Support: support@new-dev.ml\n%s version: %s.%s\nCopyright 2020 - %s, New DEV" % [str(ProjectSettings.get_setting("application/config/name")), version_string, version_commit, OS.get_date().year]
	return text
func _init():
	file.open("game_version.txt", File.READ)
	version_commit = file.get_line()
	install_base_path = OS.get_executable_path().get_base_dir() + "/"
	print("Installed at: " + install_base_path)
var dlcs:Array = [
	
]
var worlds:Array = [
	
]
var cworlds:Array = [
	
]
var levels_scan_path:Array = [
	str(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/Foxy Adventure/Levels/Editor/")
]
var dlc_name_list:Array = [
	
]
var camera_smoothing_enabled = false
var camera_smoothing_speed = 0
var temp_custom_stages_dir = "user://custom_stages/"
var gc_mode = 'realtime'
#var mod_path = str(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)) + '/Sonadow RPG/Mods/mod.pck'
func add_character(chr_name:String):
#	new_characters.insert(1, chr_name)
	new_characters.append(chr_name)
	print(str(new_characters))
func add_dlc(dlc_name:String):
	dlcs.append(dlc_name)
func add_world(world_name:String):
	worlds.append(world_name)
func add_custom_world(world_name:String):
	cworlds.append(world_name)
func add_custom_world_scan_path(path:String):
	levels_scan_path.append(path)
func set_minimap_enabled(minimap_visible):
	emit_signal("minimap", minimap_visible)
	minimap_enabled = minimap_visible
func get_minimap_enabled():
	return minimap_enabled
func _ready():
	var cfile = ConfigFile.new()
	cfile.load(Globals.install_base_path + "config.cfg")
	bits = str(cfile.get_value("config", "bits", "32"))
	##LOAD DLCS
	#Tails.exe
	
	if file.file_exists(install_base_path + 'dlcs/dlc_tails_exe.gd'):
		var script = load(install_base_path + 'dlcs/dlc_tails_exe.gd').new()
		script.add_characters()
		script.add_stages()
		script.add_dlc()
		ProjectSettings.load_resource_pack(install_base_path + 'dlcs/dlc_tails_exe.pck')
	#Classic Sonic
	
	var save_file = ConfigFile.new()
	save_file.load("user://settings.cfg")
	if save_file.has_section_key('Game', 'debug_mode'):
		debugMode = bool(str(save_file.get_value('Game', 'debug_mode')))
	if str(OS.get_name()) == "Android":
		ProjectSettings.set_setting('appilcation/config/use_custom_user_dir', true)
		ProjectSettings.set_setting('application/config/custom_user_dir_name', "storage/emulated/0/Android/data/org.godotengine/")
		ProjectSettings.save()
		ProjectSettings.save_custom('user://project.godot')
	set_process(false)

	if str(OS.get_name()) == 'Android':
		debugMode = false
	emit_signal("debugModeSet", debugMode)
	emit_signal("loaded")


func set_variable(variable, value):
	set(variable, value)

func apply_custom_resolution():
	OS.set_window_size(Vector2(window_x_resolution, window_y_resolution))


func scan_dlcs(path = 'user://dlcs/'):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				if file_name.get_extension() == 'pck':
					if file_name.begins_with('dlc'):
						dlcs.append(str(file_name.get_basename()))
						var err = ProjectSettings.load_resource_pack(file_name)
						if err == false:
							OS.alert('Error while loading DLC:\n' + str(file_name.get_basename()) + '\n\nClick OK to continue')
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")


func save_level(stage:int, save_name:String):
	var sonyk = ConfigFile.new()
	sonyk.load("user://save_"+save_name+".cfg")
	sonyk.set_value("save", "stage", stage)
	sonyk.set_value("save", "character", character_path)
	sonyk.save("user://save_"+save_name+".cfg")
#	sonyk.close()

func load_level(save_name:String):
	var sonyk = ConfigFile.new()
	sonyk.load("user://save_"+save_name+".cfg")
	var stage = sonyk.get_value("save", "stage")
	var character_pth = sonyk.get_value("save", "character")
	character_path = character_pth
	selected_character = load(character_pth).instance()
	var loaded_stage = stage_list[str(stage)]
	BackgroundLoad.load_scene(loaded_stage)

func game_over():
	get_tree().change_scene("res://Scenes/GameOver.tscn")
