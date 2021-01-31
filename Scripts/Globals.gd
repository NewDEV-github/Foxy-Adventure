extends Node
#var project_root_dir = get_project_root_dir()
var bits = "32"
var copy_file_list = [
	"res://rpc/rpc.py",
	"res://rpc/rpc-kill.py",
	"res://rpc/rpc-newtf.py",
	"res://rpc/rpc-tails.py",
]
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
var core: Discord.Core
var users: Discord.UserManager
var images: Discord.ImageManager
var activitytimestamps: Discord.ActivityTimestamps
var activityassets: Discord.ActivityAssets
var partysize: Discord.PartySize
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

func _on_current_user_update() -> void:
	users.get_current_user(self, "get_current_user_callback")
	users.get_current_user_premium_type(
		self, "get_current_user_premium_type_callback"
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
#
#		var handle: = Discord.ImageHandle.new()
#		handle.id = user.id
#		handle.size = 256
#		handle.type = Discord.ImageType.USER
#
#		images.fetch(handle, true, self, "fetch_callback")

func get_user_callback(result: int, user: Discord.User) -> void:
	if result == Discord.Result.OK:
		print("Fetched User:")
		print(user.username, "#", user.discriminator, "  ID: ", user.id)
	else:
		print("Failed to fetch user: ", enum_to_string(Discord.Result, result))

func get_current_user_premium_type_callback(
	result: int,
	premium_type: int
) -> void:
	if result != Discord.Result.OK:
		print(
			"Failed to get user premium type: ",
			enum_to_string(Discord.Result, result)
		)
	else:
		print("Current User Premium Type:")
		print(enum_to_string(Discord.PremiumType, premium_type))

#func fetch_callback(result: int, handle: Discord.ImageHandle) -> void:
#	if result != Discord.Result.OK:
#		print(
#			"Failed to fetch image handle: ",
#			enum_to_string(Discord.Result, result)
#		)
#	else:
#		print("Fetched image handle, ", handle.id, ", ", handle.size)
#
#		var res = images.get_data(handle)
#		if res is int:
#			print(
#				"Failed to get image data: ",
#				enum_to_string(Discord.Result, res)
#			)
#		else:
#			var dimensions: Discord.ImageDimensions = images.get_dimensions(handle)
#			var image: = Image.new()
#			image.create_from_data(
#				dimensions.width, dimensions.height,
#				false,
#				Image.FORMAT_RGBA8,
#				res
#			)
#			image.unlock()
#			var tex: = ImageTexture.new()
#			tex.create_from_image(image)
#			texture_rect.texture = tex
#			OS.window_size = Vector2(dimensions.width, dimensions.height)
func _ready():
	Fmod.set_software_format(0, Fmod.FMOD_SPEAKERMODE_STEREO, 0)
	Fmod.init(1024, Fmod.FMOD_STUDIO_INIT_LIVEUPDATE, Fmod.FMOD_INIT_NORMAL)
	core = Discord.Core.new()
	var result: int = core.create(
		793449535632441374,
		Discord.CreateFlags.DEFAULT
	)
	print("Created Discord Core: ", enum_to_string(Discord.Result, result))
	if result != Discord.Result.OK:
		core = null
	else:
		activitytimestamps = Discord.ActivityTimestamps.new()
		activityassets = Discord.ActivityAssets.new()
		activityassets.small_text = "D"
		users = _get_user_manager()
		users.connect("current_user_update", self, "_on_current_user_update")

		users.get_user(708014517975777302, self, "get_user_callback")

		images = _get_image_manager()
	copy_files_rpc()
#	print("Project root dir is at: " + project_root_dir)
	cfile.load(install_base_path + "config.cfg")
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
	emit_signal("debugModeSet", debugMode)
	emit_signal("loaded")
func get_project_root_dir():
	return "res://".get_base_dir()
#DISCORD RPC
var rpc_pid
var rpc_pid_development
var is_developer = false
func copy_files_rpc():
	if file.file_exists(install_base_path + "config.cfg"):
		cfile.load(install_base_path + "config.cfg")
#RPC Script
		dir.copy("res://rpc/rpc.py", install_base_path + "rpc.py")
		cfile.set_value("files", "res://rpc/rpc.py", "rpc.py")
#RPC Tails Script
		dir.copy("res://rpc/rpc-tails.py", install_base_path + "rpc-tails.py")
		cfile.set_value("files", "res://rpc/rpc-tails.py", "rpc-tails.py")
#RPC New The Fox Script
		dir.copy("res://rpc/rpc-newtf.py", install_base_path + "rpc-newtf.py")
		cfile.set_value("files", "res://rpc/rpc-newtf.py", "rpc-newtf.py")
#RPC Kill Script
		dir.copy("res://rpc/rpc-kill.py", install_base_path + "rpc-kill.py")
		cfile.set_value("files", "res://rpc/rpc-kill.py", "rpc-kill.py")
		
		cfile.save(install_base_path + "config.cfg")

func RPCDevelopment():
	is_developer = true
	if os_rpc.has(OS.get_name()):
		print("Starting RPC...")
		if file.file_exists("rpc/rpc-development.py"):
			rpc_pid_development = OS.execute("python", ["rpc/rpc-developmnet.py"], false)
		print("RPC started as mysterious developer, with pid: " + str(rpc_pid_development))
var os_rpc = ["Windows", "X11", "OSX"]
func RPCTails():
	is_developer = false
	if os_rpc.has(OS.get_name()):
		print("Starting RPC...")
		if file.file_exists(install_base_path +"rpc-tails.py"):
			rpc_pid = OS.execute("python", [install_base_path + "rpc-tails.py"], false)
		elif not file.file_exists(install_base_path + "rpc-tails.py"):
			rpc_pid = OS.execute("python", ["rpc/rpc-tails.py"], false)
		print("RPC started as Tails, with pid: " + str(rpc_pid))
		
func RPCNewTF():
	is_developer = false
	print("Starting RPC...")
	if os_rpc.has(OS.get_name()):
		if file.file_exists(install_base_path + "rpc-newtf.py"):
			rpc_pid = OS.execute("python", [install_base_path + "rpc-newtf.py"], false)
		elif not file.file_exists(install_base_path + "rpc-newtf.py"):
			rpc_pid = OS.execute("python", ["rpc/rpc-newtf.py"], false)
		print("RPC started as New The Fox, with pid: " + str(rpc_pid))
func RPCKill():
	print("Killing RPC...")
	if os_rpc.has(OS.get_name()):
		if file.file_exists(install_base_path + "rpc-kill.py"):
			OS.execute("python", [install_base_path + "rpc-kill.py"], false)
		elif not file.file_exists(install_base_path + "rpc-kill.py"):
			OS.execute("python", ["rpc/rpc-kill.py"], false)
	if not rpc_pid == null:
		if not is_developer:
			OS.kill(int(rpc_pid))
		elif is_developer:
			OS.kill(int(rpc_pid_development))
		print("RPC killed")
func set_variable(variable, value):
	set(variable, value)
func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or what== MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		RPCKill()
	if what == MainLoop.NOTIFICATION_CRASH:
		OS.alert("App crashed. Error log was sent to Developers!", "Error!")
		send_crash_log_msg()
func apply_custom_resolution():
	OS.set_window_size(Vector2(window_x_resolution, window_y_resolution))
func send_crash_log_msg():
	var http = HTTPRequest.new()
	var f = File.new()
	f.open("user://logs/engine_log.txt", File.READ)
	var new_text = "<@&763764844381864007> \n\n" + str(f.get_as_text()) + "\n\n**OS:** " + str(OS.get_name()) + "\n**Godot version:** " + str(Engine.get_version_info()) + "\n**Debug build:** " + str(OS.is_debug_build())
	var headers := ["Content-Type: application/json"]
	var myEmbed = {
		"author": {
			"name": "Foxy Adventure"
		},
		"title": "Game Crashed!!!",
		"description": new_text,
		"color": "16711680"
		}
#	var headers := ["Content-Type: application/json"]
	var params = {
		"username": "In-game errors",
		"embeds": [myEmbed],
	}
	var msg = {"content": "", "embed": {"title": "New error catched up!", "description": new_text}}
	var query = JSON.print(params)
#	var channel_id = "773150027106484234"
	f.close()
	http.request(Marshalls.base64_to_utf8(str(SharedLibManager.webhook_err.get_data())), headers, true, HTTPClient.METHOD_POST, query)

func save_level(stage:int, save_name:String):
	var sonyk = ConfigFile.new()
	sonyk.load("user://save_"+save_name+".cfg")
	sonyk.set_value("save", "stage", stage)
	sonyk.set_value("save", "character", character_path)
	sonyk.set_value("save", "coins", str(coins))
	sonyk.save("user://save_"+save_name+".cfg")
#	sonyk.close()

func load_level(save_name:String):
	var sonyk = ConfigFile.new()
	sonyk.load("user://save_"+save_name+".cfg")
	var stage = sonyk.get_value("save", "stage")
	var character_pth = sonyk.get_value("save", "character")
	coins = int(sonyk.get_value("save", "coins"))
	character_path = character_pth
	selected_character = load(character_pth).instance()
	var loaded_stage = stage_list[str(stage)]
	BackgroundLoad.load_scene(loaded_stage)
func game_over():
	get_tree().change_scene("res://Scenes/GameOver.tscn")
	RPCKill()

