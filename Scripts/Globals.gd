extends Node
signal loaded
signal minimap
signal nsfw
var minimap_enabled = true setget set_minimap_enabled, get_minimap_enabled
var debugMode
var coming_from_house = ''
var object_transparency = 0.65
var selected_character
var character_path
var world
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
	
]
var fmod_sound_music_instance
var fmod_sound_sfx_instance
var fmod_event_sound_instance
var fmod_event_sfx_instance
var fmod_perf_data
func _loadfmod():
	# set up FMOD
	Fmod.set_software_format(0, Fmod.FMOD_SPEAKERMODE_STEREO, 0)
	Fmod.init(1024, Fmod.FMOD_STUDIO_INIT_LIVEUPDATE, Fmod.FMOD_INIT_NORMAL)
	Fmod.set_sound_3D_settings(1, 32, 1)
	Fmod.set_listener_number(2)
	
	# load banks
# warning-ignore:return_value_discarded
	Fmod.load_bank("res://assets/Banks/Master Bank.strings.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
# warning-ignore:return_value_discarded
	Fmod.load_bank("res://assets/Banks/Master Bank.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
# warning-ignore:return_value_discarded
	Fmod.load_bank("res://assets/Banks/Music.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
# warning-ignore:return_value_discarded
	Fmod.load_bank("res://assets/Banks/Vehicles.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
	print("Fmod initialised.")
	var drivers = Fmod.get_available_drivers()
	print(drivers)
func get_dlcs_avaliable():
#	var http = HTTPRequest.new()
#	var req = http.request('https://www.sonadow-rpg.ml/dlcs/index.html')
#	if req == OK:
#		return true
#	elif req == FAILED:
#		return false
	return true
var dlcs:Array = [
	
]
var worlds:Array = [
	
]
var dlc_name_list:Dictionary = {
	"Foxes":"dlc_foxes",
	"Baby Sonadow":"dlc_babysonadow"
	
}
var gc_mode = 'realtime'
var mod_path = str(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)) + '/Sonadow RPG/Mods/mod.pck'
func add_character(chr_name:String):
	new_characters.append(chr_name)
func add_dlc(dlc_name:String):
	dlcs.append(dlc_name)
func add_world(world_name:String):
	worlds.append(world_name)
func set_minimap_enabled(minimap_visible):
	emit_signal("minimap", minimap_visible)
	minimap_enabled = minimap_visible
func get_minimap_enabled():
	return minimap_enabled
func _ready():
	var save_file = ConfigFile.new()
	save_file.load("user://settings.cfg")
	if save_file.has_section_key('Game', 'debug_mode'):
		Globals.debugMode = bool(str(save_file.get_value('Graphics', 'debug_mode', false)))
	_loadfmod()
	if str(OS.get_name()) == "Android":
		ProjectSettings.set_setting('appilcation/config/use_custom_user_dir', true)
		ProjectSettings.set_setting('application/config/custom_user_dir_name', "storage/emulated/0/Android/data/org.godotengine.sonadowrpg/")
		ProjectSettings.save()
		ProjectSettings.save_custom('user://project.godot')
	set_process(false)
	timer.wait_time = game_hour
	timer.connect("timeout", self, "on_timer_timeout")
	if str(OS.get_name()) == 'Android':
		debugMode = false
	emit_signal("debugModeSet", debugMode)
	emit_signal("loaded")
func save_game():
	cfile.load('user://save.cfg')
	cfile.set_value('savedata', 'character', str(character_path))
	cfile.set_value('savedata', 'last_world_position_y', last_world_position.y)
	cfile.set_value('savedata', 'last_world_position_x', last_world_position.x)
	cfile.set_value('savedata', 'world', str(world))
	cfile.set_value('savedata', 'time', str(hour))
	cfile.save('user://save.cfg')
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
