extends Node
var bits = 32
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
var timer = Timer.new()
var hour
var nsfw
var new_characters:Array = [
	"NewTheFox",
	"Tails",
]
func _init():
	install_base_path = OS.get_executable_path().get_base_dir() + "/"
	print(install_base_path)
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
	cfile.free()
	##LOAD DLCS
	#LEO
	
	if file.file_exists('res://dlcs/dlc_leo.gd') and file.file_exists('user://dlcs/dlc_leo.pck'):
		var script = load('res://dlcs/dlc_leo.gd').new()
		script.add_characters()
		script.add_stages()
		script.add_dlc()
		ProjectSettings.load_resource_pack("user://dlcs/dlc_leo.pck")
	#Classic Sonic
	if file.file_exists('res://dlcs/dlc_classic_sonic.gd') and file.file_exists('user://dlcs/dlc_classic_sonic.pck'):
		var script = load('res://dlcs/dlc_classic_sonic.gd').new()
		script.add_characters()
		script.add_stages()
		script.add_dlc()
		ProjectSettings.load_resource_pack("user://dlcs/dlc_classic_sonic.pck")
	#New.exe
	if file.file_exists('res://dlcs/dlc_new_exe.gd') and file.file_exists('user://dlcs/dlc_new_exe.pck'):
		var script = load('res://dlcs/dlc_new_exe.gd').new()
		script.add_characters()
		script.add_stages()
		script.add_dlc()
		ProjectSettings.load_resource_pack("user://dlcs/dlc_new_exe.pck")
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
	timer.wait_time = game_hour
	timer.connect("timeout", self, "on_timer_timeout")
	if str(OS.get_name()) == 'Android':
		debugMode = false
	emit_signal("debugModeSet", debugMode)
	emit_signal("loaded")
func set_day_night_mode(mode:String):
	gc_mode = mode
	if mode == 'realtime':
		hour = OS.get_time().hour
		set_process(true)
	if mode == 'gametime':
		timer.start()

func _process(_delta):
#	fmod_perf_data = Fmod.get_performance_data()
	hour = OS.get_time().hour

func on_timer_timeout():
	hour += 1
func set_variable(variable, value):
	set(variable, value)

func apply_custom_resolution():
	OS.set_window_size(Vector2(window_x_resolution, window_y_resolution))
func set_nsfw(nsfw_enabled:bool):
	nsfw = nsfw_enabled
	emit_signal("nsfw", nsfw_enabled)


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


func save_level(stage:int):
	var sonyk = ConfigFile.new()
	sonyk.load("user://save.cfg")
	sonyk.set_value("save", "stage", stage)
	sonyk.save("user://save.cfg")
#	sonyk.close()

func game_over():
	get_tree().change_scene("res://Scenes/GameOver.tscn")
