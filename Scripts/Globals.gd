extends Node
#var project_root_dir = get_project_root_dir()
var bits = "32"
var activities: Discord.ActivityManager
var users: Discord.UserManager
var os_rpc = ["Windows", "X11", "OSX"]

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
var stage_names:Dictionary = {
	"0": "Metallic Madness Act 1",
	"1": "Metallic Madness Act 2",
	"2": "Metallic Madness Act 3",
	
}
var current_stage = 0
var core: Discord.Core
#var feedback_script = preload("res://FeedBack/Main.gd").new()
signal debugModeSet
signal loaded
var fps_visible = true
var timer_visible = true
var install_base_path = OS.get_executable_path().get_base_dir() + "/"
var debugMode = false
var selected_character
var character_path
var release_mode = false
var window_x_resolution = 1024
var window_y_resolution = 600
var character_position
var last_world_position = Vector2(0,0)
var cfile = ConfigFile.new()
var file =  File.new()
var dir = Directory.new()
var version_string:String = "alpha"
var version_commit:String = "unknown"
var current_save_name = ""
var coins = 0
var new_characters:Array = [
	"New The Fox",
	"Tails",
]

func construct_game_version():
	var text = "Support: support@new-dev.ml\n%s version: %s\nCopyright 2020 - %s, New DEV" % [str(ProjectSettings.get_setting("application/config/name")), version_string, OS.get_date().year]
	return text
func _init():
	version_commit = "idk"
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
func enum_to_string(the_enum: Dictionary, value: int) -> String:
	var index: = the_enum.values().find(value)
	var string: String = the_enum.keys()[index]
	return string
func _get_user_manager() -> Discord.UserManager:
	var result = core.get_user_manager()
	if result is int:
		print(
			"Failed to get user manager: ",
			enum_to_string(Discord.Result, result)
		)
		return null
	else:
		return result

func _get_image_manager() -> Discord.ImageManager:
	var result = core.get_image_manager()
	if result is int:
		print(
			"Failed to get image manager: ",
			enum_to_string(Discord.Result, result)
		)
		return null
	else:
		return result
func _process(_delta: float) -> void:
	if core:
		var result: int = core.run_callbacks()
		if result != Discord.Result.OK:
			print("Callbacks failed: ", enum_to_string(Discord.Result, result))

func _ready():
#	execute_debugging_tools()
	if os_rpc.has(OS.get_name()):
		core = Discord.Core.new()
		var result: int = core.create(
			729429191489093702,
			Discord.CreateFlags.DEFAULT
		)
		print("Created Discord Core: ", enum_to_string(Discord.Result, result))
		if result != Discord.Result.OK:
			core = null
		else:
			users = _get_user_manager()
			users.connect("current_user_update", self, "_on_current_user_update")
			activities = _get_activity_manager()
			core.set_log_hook(Discord.LogLevel.DEBUG, self, "log_hook")
			activities.register_command(str(OS.get_executable_path()))
	else:
		print("Can not start Discord Core")
#	print("Project root dir is at: " + project_root_dir)
	if OS.has_feature("64") or OS.has_feature("x86_64"):
		bits == "64"
	elif OS.has_feature("32") or OS.has_feature("x86"):
		bits == "32"
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
	emit_signal("debugModeSet", debugMode)
	emit_signal("loaded")
func get_project_root_dir():
	return "res://".get_base_dir()

func run_rpc(developer, display_stage, character="Tails", is_in_menu=false):
	if Discord.Core != null:
		if os_rpc.has(OS.get_name()):
			print("Starting RPC...")
			var activity: = Discord.Activity.new()
			if not developer and not is_in_menu:
				activity.details = "Playing as %s" % [character]
				if display_stage:
					activity.state = "At %s" % [stage_names[str(current_stage)]]
			elif developer:
				activity.details = "I'm making the game for You now"
			elif is_in_menu:
				activity.details = "At main menu"
			activity.assets.large_image = "icon"

			activity.timestamps.start = OS.get_unix_time()

			activities.update_activity(activity, self, "update_activity_callback")
			if not developer:
				print("RPC started as %s" % [character])
			else:
				print("RPC started as mysterious developer")
	else:
		print("Can not start Discord Core")
func RPCKill():
	if Discord.Core != null:
		print("Killing RPC...")
		if os_rpc.has(OS.get_name()):
			activities.clear_activity()
			print("RPC killed")
	else:
		print("Can not start Discord Core")
func set_variable(variable, value):
	set(variable, value)
func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_CRASH:
		OS.alert("App crashed. Error log was sent to Developers!", "Error!")
func apply_custom_resolution():
	OS.set_window_size(Vector2(window_x_resolution, window_y_resolution))

func save_level(stage:int, save_name:String):
	var sonyk = ConfigFile.new()
	sonyk.load("user://save_"+save_name+".cfg")
	sonyk.set_value("save", "stage", stage)
	sonyk.set_value("save", "character", character_path)
	sonyk.set_value("save", "coins", str(coins))
	sonyk.save("user://save_"+save_name+".cfg")
#	sonyk.close()
func delete_save(save_name:String):
	dir.remove("user://save_"+save_name+".cfg")
func load_level(save_name:String):
	var sonyk = ConfigFile.new()
	sonyk.load("user://save_"+save_name+".cfg")
	var stage = sonyk.get_value("save", "stage")
	var character_pth = sonyk.get_value("save", "character")
	if sonyk.has_section_key("save", "coins"):
		coins = int(sonyk.get_value("save", "coins"))
	character_path = character_pth
	selected_character = load(character_pth).instance()
	var loaded_stage = stage_list[str(stage)]
	BackgroundLoad.play_start_transition = true
	BackgroundLoad.load_scene(loaded_stage)
func game_over():
	get_tree().change_scene("res://Scenes/GameOver.tscn")
	RPCKill()
#func execute_debugging_tools():
#	if file.file_exists(install_base_path + "DebuggingTools.exe"):
#		OS.execute(install_base_path + "DebuggingTools.exe", [], false)
func update_activity_callback(result: int):
	if result == Discord.Result.OK:
		print("Updated Activity Successfully")
	else:
		print(
			"Failed to update activity: ",
			enum_to_string(Discord.Result, result)
		)
func _get_activity_manager() -> Discord.ActivityManager:
	var result = core.get_activity_manager()
	if result is int:
		print(
			"Failed to get activity manager: ",
			enum_to_string(Discord.Result, result)
		)
		return null
	else:
		return result
func log_hook(level: int, message: String) -> void:
	print(
		"[Discord SDK] ",
		enum_to_string(Discord.LogLevel, level),
		": ", message
	)
func get_current_user_callback(result: int, user: Discord.User) -> void:
	if result != Discord.Result.OK:
		print(
			"Failed to get user: ",
			enum_to_string(Discord.Result, result)
		)
	else:
		print("Got Current User:")
		print(user.username, "#", user.discriminator, "  ID: ", user.id)
func _on_current_user_update() -> void:
	users.get_current_user(self, "get_current_user_callback")
	users.get_current_user_premium_type(
		self, "get_current_user_premium_type_callback"
	)


