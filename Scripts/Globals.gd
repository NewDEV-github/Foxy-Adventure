extends Node
var loaded = false
var gdsdk_enabled = true
signal scoredatarecived
var fallen_into_toxins = 0
signal achivement_done(achivement)
var user_data = {}
var supported_sdk_versions = [
	110,
	111
	
]
#var packs = [install_base_path + "/packs/core/scenes.pck", install_base_path + "/packs/core/scripts.pck"]
var custom_menu_bg = ""
var custom_menu_audio = ""
var called_from_menu = false
var called_from_menu_level_name = ""
var level_name_org = "nounnamed"
var level_description = "example"
var level_author = "DoS"
var level_version = "v1.0.0"
var level_name = "nonunnamed"
var level_path = str(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/New DEV/Foxy Adventure/Levels/Editor/")
var erase_tiles = false
var flip_tiles_x = false
var flip_tiles_y = false
var current_tile_name = "sci-fi-tileset.png 4"
var all_achievements = [
	tr("KEY_TEXT_ACHIVEMENT_1"),
	tr("KEY_TEXT_ACHIVEMENT_2"),#done
	tr("KEY_TEXT_ACHIVEMENT_3"),#done
	tr("KEY_TEXT_ACHIVEMENT_4"),#done
	tr("KEY_TEXT_ACHIVEMENT_5"),#done
	tr("KEY_TEXT_ACHIVEMENT_6"),#done
	tr("KEY_TEXT_ACHIVEMENT_7"),#done
	tr("KEY_TEXT_ACHIVEMENT_8"),#done
]
var discord_sdk_enabled = false
var done_achievements = []
var not_done_achievements = all_achievements
var achievements_desc = {
	tr("KEY_TEXT_ACHIVEMENT_1"): tr("KEY_TEXT_ACHIVEMENT_DESCRIPTION_1"),
	tr("KEY_TEXT_ACHIVEMENT_2"): tr("KEY_TEXT_ACHIVEMENT_DESCRIPTION_2"),
	tr("KEY_TEXT_ACHIVEMENT_3"): tr("KEY_TEXT_ACHIVEMENT_DESCRIPTION_3"),
	tr("KEY_TEXT_ACHIVEMENT_4"): tr("KEY_TEXT_ACHIVEMENT_DESCRIPTION_4"),
	tr("KEY_TEXT_ACHIVEMENT_5"): tr("KEY_TEXT_ACHIVEMENT_DESCRIPTION_5"),
	tr("KEY_TEXT_ACHIVEMENT_6"): tr("KEY_TEXT_ACHIVEMENT_DESCRIPTION_6"),
	tr("KEY_TEXT_ACHIVEMENT_7"): tr("KEY_TEXT_ACHIVEMENT_DESCRIPTION_7"),
	tr("KEY_TEXT_ACHIVEMENT_8"): tr("KEY_TEXT_ACHIVEMENT_DESCRIPTION_8"),
}
var stage_list = {
	"0": "res://Scenes/Stages/poziom_1.tscn",
	"1": "res://Scenes/Credits.tscn"
}
var stage_names:Dictionary = {
	"0": tr("KEY_TEXT_STAGE_LABORATORY") + " - 1",
	"1": tr("KEY_TEXT_STAGE_LABORATORY") + " - 2",
	"2": tr("KEY_TEXT_STAGE_LABORATORY") + " - 3",
	"3": tr("KEY_TEXT_STAGE_CREDITS") + " :3"
}
func change_stage(stage_id:String):
	BackgroundLoad.get_node("bgload").load_scene(stage_list[stage_id])
func add_stage_to_list(stage_path:String, stage_name:String):
	stage_list[stage_list.size()] = stage_path
	stage_names[stage_list.size()] = stage_name
func replace_stage_in_list(id:String, stage_path:String, stage_name:String):
	stage_list[id] = stage_path
	stage_names[id] = stage_name
func set_stage_list(list:Dictionary):
	stage_list = list
func set_stage_name(id:String, stage_name:String):
	stage_names[id] = stage_name

func get_current_position_in_list_by_path(path):
	for i in stage_list:
		if stage_list[i] == path:
			return i
		else:
			pass
var current_stage = 0
var arguments = {}
#var feedback_script = preload("res://FeedBack/Main.gd").new()
signal debugModeSet
signal loaded
var fps_visible = true
var timer_visible = true
var install_base_path = OS.get_executable_path().get_base_dir() + "/"
var debugMode = false
var selected_character
var character_path = "res://Scenes/Characters/Tails.tscn"
var release_mode = false
var window_x_resolution = 1024
var window_y_resolution = 600
var character_position
var last_world_position = Vector2(0,0)
var cfile = ConfigFile.new()
var file =  File.new()
var dir = Directory.new()
var current_save_name = ""
var coins = 0
var lives = 5
var new_characters:Dictionary = {
	"Tails": "res://Scenes/Characters/Tails.tscn",
}
var game_version_text = "Support: [url]https://newdev.web.app/contact[/url]\n%s\nCopyright 2020 - %s, New DEV" % [str(ProjectSettings.get_setting("application/config/name")), OS.get_date().year]
signal game_version_text_changed(text)
func construct_game_version():
	emit_signal("game_version_text_changed", game_version_text)
func _init():
	for argument in OS.get_cmdline_args():
		# Parse valid command-line arguments into a dictionary
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
		else:
			arguments[argument.lstrip("--")] = ""
	if file.file_exists("user://achievements.cfg"):
		load_achivements()
	install_base_path = OS.get_executable_path().get_base_dir() + "/"
	
	var f = File.new()
	f.open("user://sdk_data", File.WRITE)
	for i in supported_sdk_versions:
		var line = str(i)
		f.store_line(line)
	f.close()
	
	print("Installed at: " + install_base_path)
	print("Runned with arguments: " + str(arguments))
#	if not arguments.has("editor"):
#		for i in packs:
#			ProjectSettings.load_resource_pack(i)
	OS.window_borderless = false
var dlcs:Array = [
	
]
var worlds:Dictionary = {
	
}
var cworlds:Dictionary = {
	
}
var levels_scan_path:Array = [
	str(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/New DEV/Foxy Adventure/Levels/Editor/"),
	str(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/New DEV/Foxy Adventure Level Editor/")
]
var dlc_name_list:Array = [
	
]
var camera_smoothing_enabled = false
var camera_smoothing_speed = 0
var temp_custom_stages_dir = "user://custom_stages/"
var gc_mode = 'realtime'
var _very_tmp_character_instance = null
var _very_tmp_character_instance_path = null
func get_current_character_name_from_list():
	for i in new_characters:
		if new_characters[i] == character_path:
			return i
func get_current_character_name():
	if _very_tmp_character_instance == null:
		_very_tmp_character_instance = load(str(character_path)).instance()
		_very_tmp_character_instance_path = character_path
	else:
		if _very_tmp_character_instance_path != character_path:
			_very_tmp_character_instance = load(str(character_path)).instance()
			_very_tmp_character_instance_path = character_path
	return _very_tmp_character_instance.name
func enable_discord_sdk(en):
	discord_sdk_enabled = en
	var cfg = ConfigFile.new()
	cfg.load("user://settings.cfg")
	cfg.set_value('Game', 'discord_sdk_enabled', str(en))
	cfg.save("user://settings.cfg")
#var mod_path = str(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)) + '/Sonadow RPG/Mods/mod.pck'
func add_character(chr_name:String, path:String):
	new_characters[chr_name] = path
func add_dlc(dlc_name:String):
	dlcs.append(dlc_name)
func add_world(world_name:String, path:String):
	worlds[world_name] = path
func add_custom_world(world_name:String, path:String):
	if not cworlds.has(world_name):
		cworlds[world_name] = path
	else:
		print("Stage named " + world_name + "\nis already imported into the game.", "Oops!")
func add_custom_world_scan_path(path:String):
	levels_scan_path.append(path)

func add_lifes(anmount):
	lives += anmount
	if lives == 9:
		set_achievement_done(tr("KEY_TEXT_ACHIVEMENT_7"))
	elif lives >= 9:
		set_achievement_done(tr("KEY_TEXT_ACHIVEMENT_8"))
func remove_lifes(anmount):
	lives -= anmount
func is_world_from_dlc_or_mod(world:String):
	return worlds.has(world) #true if world is from dlc or mod, false if its from editor
func set_lifes(anmount):
	lives = anmount

func remove_coins(anmount):
	coins -= anmount

func set_coins(anmount):
	coins = anmount

func add_coin(anmount, upload_score=false):
#	if user_data.has("localid"):
#		print(user_data["localid"])
#		ApiScores.update_score(user_data["localid"], anmount)
	coins += anmount
	
#	print(str(int(coins) % 100))
	if int(coins) % 100 == 0:
		add_lifes(0)
	if coins == 50:
		set_achievement_done(tr("KEY_TEXT_ACHIVEMENT_5"))
	elif coins == 100:
		set_achievement_done(tr("KEY_TEXT_ACHIVEMENT_6"))

func felt_into_toxine():
	fallen_into_toxins += 1
	if fallen_into_toxins == 5:
		set_achievement_done(tr("KEY_TEXT_ACHIVEMENT_3"))
	elif fallen_into_toxins == 15:
		set_achievement_done(tr("KEY_TEXT_ACHIVEMENT_4"))
	get_tree().reload_current_scene()
	emit_signal("scoredatarecived")

func _ready():
	get_tree().get_root().set_transparent_background(true)
#	OS.execute(OS.get_executable_path(), ["--send-log"], false)
#	OS.shell_open(OS.get_executable_path() + " --send-log")
#	get_tree().quit()
	if arguments.has("send-log"):
		OS.shell_open(install_base_path + "send_log/send_log")
#		ApiLogs.send_debug_log_to_database()
#		yield(ApiLogs, "recived_log_id")
#		OS.alert("Your log was sent\n\nHere is log id: (0)" + str(ApiLogs.tmp_log_id))
		get_tree().quit()
	if arguments.has("locale"):
		print("Setting locale to: " + arguments["locale"])
		TranslationServer.set_locale(arguments["locale"])
	var dir = Directory.new()
	if not dir.dir_exists(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/New DEV/Foxy Adventure/Mods/"):
		dir.make_dir_recursive(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/New DEV/Foxy Adventure/Mods/")
	var conf = ConfigFile.new()
	if file.file_exists("user://settings.cfg"):
		conf.load("user://settings.cfg")
		if conf.has_section_key('Game', 'discord_sdk_enabled'):
			discord_sdk_enabled = bool(conf.get_value('Game', 'discord_sdk_enabled'))
	var date = OS.get_date()
	if date.day == 1 and date.month == 4:
		ErrorCodeServer.treat_error(ErrorCodeServer.ERR_WTF)
		ErrorCodeServer.treat_error(ErrorCodeServer.ERR_PC_ON_FIRE)
	if file.file_exists('user://dlcs/betatests/config.cfg'):
		stage_list = {
			"0": "res://Scenes/Stages/poziom_1.tscn",
			"1": "res://Scenes/Stages/poziom_2.tscn",
			"2": "res://Scenes/Stages/poziom_3.tscn",
			"3": "res://Scenes/Credits.tscn"
		}
	if file.file_exists('user://dlcs/fadlc01/foxy_adventure_dlc01.cfg'):
		conf.load('user://dlcs/fadlc01/foxy_adventure_dlc01.cfg')
		for i in conf.get_value("mod_info", "pck_files"):
			ProjectSettings.load_resource_pack('user://dlcs/fadlc01/' + i)
		var script = load(conf.get_value("mod_info", "main_script_file")).new()
		script.init_mod()
		conf.save('user://dlcs/fadlc01/foxy_adventure_dlc01.cfg')
	### ITAM_EDITION
#		conf.save(install_base_path + 'dlcs/tox_edition.cfg')

	#Classic Sonic

	var save_file = ConfigFile.new()
	save_file.load("user://settings.cfg")
	if save_file.has_section_key('Game', 'debug_mode'):
		debugMode = bool(str(save_file.get_value('Game', 'debug_mode')))
	emit_signal("debugModeSet", debugMode)
	if not file.file_exists("user://achievements.cfg"):
		generate_achievements_file()
	scan_and_load_modifications_cfg()
	for i in modifications:
		load_modification(i)
	loaded = true
	get_tree().get_root().set_transparent_background(false)
func get_project_root_dir():
	return "res://".get_base_dir()


func set_variable(variable, value):
	set(variable, value)
func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_CRASH:
		OS.alert("App crashed!", "Error!")
#		OS.shell_open(OS.get_executable_path() + " --send-log")
		OS.shell_open(install_base_path + "send_log/send_log")
		get_tree().quit()
func apply_custom_resolution():
	OS.set_window_size(Vector2(window_x_resolution, window_y_resolution))

func save_level(stage:int, save_name:String):
#	SavingDataIcon.show_up(true, 4)
	var sonyk = ConfigFile.new()
	sonyk.load("user://save_"+save_name+".cfg")
	sonyk.set_value("save", "stage", stage)
	sonyk.set_value("save", "character", character_path)
	sonyk.set_value("save", "coins", str(coins))
	sonyk.set_value("save", "lives", str(lives))
	sonyk.save("user://save_"+save_name+".cfg")
#	sonyk.close()
func delete_save(save_name:String):
	dir.remove("user://save_"+save_name+".cfg")
func load_level(save_name:String):
#	SavingDataIcon.show_up(true, 4)
	var sonyk = ConfigFile.new()
	sonyk.load("user://save_"+save_name+".cfg")
	var stage = sonyk.get_value("save", "stage")
	var character_pth = sonyk.get_value("save", "character")
	if sonyk.has_section_key("save", "coins"):
		coins = int(sonyk.get_value("save", "coins"))
	if sonyk.has_section_key("save", "lives"):
		lives = int(sonyk.get_value("save", "lives"))
	character_path = character_pth
	selected_character = load(character_pth).instance()
	var loaded_stage = stage_list[str(stage)]
	BackgroundLoad.get_node("bgload").play_start_transition = true
	BackgroundLoad.get_node("bgload").load_scene(loaded_stage)
func game_over():
	if lives != 1:
		get_tree().reload_current_scene()
		lives -= 1
	elif lives == 1:
		get_tree().change_scene("res://Scenes/GameOver.tscn")
		set_achievement_done(tr("KEY_TEXT_ACHIVEMENT_2"))
		DiscordSDK.kill_rpc()
		
var cnf = ConfigFile.new()
func generate_achievements_file():
	cnf.load("user://achievements.cfg")
	cnf.set_value("achievements", "all", all_achievements)
	cnf.set_value("achievements", "desc", achievements_desc)
	cnf.set_value("achievements", "not_done", not_done_achievements)
	cnf.set_value("achievements", "done", done_achievements)
	cnf.save("user://achievements.cfg")
func set_achievement_done(achievement_name:String):
	if not_done_achievements.has(achievement_name):
		not_done_achievements.remove(not_done_achievements.find(achievement_name))
		done_achievements.append(achievement_name)
		generate_achievements_file()
		emit_signal("achivement_done", achievement_name)
	elif done_achievements.has(achievement_name):
		print("This achievement has been already done")


#signal achivements_loaded
func load_achivements():
	cnf.load("user://achievements.cfg")
	not_done_achievements = cnf.get_value('achievements', 'not_done')
	done_achievements = cnf.get_value('achievements', 'done')
#	print(not_done_achievements)
#	print(done_achievements)
#	emit_signal("achivements_loaded")
#func _process(delta):
#	print(discord_sdk_enabled)



var modifications = {}
func scan_and_load_modifications_cfg():
	print("Scanning all modifications...")
	var cfg = ConfigFile.new()
	var dir = Directory.new()
	if not dir.dir_exists(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/New DEV/Foxy Adventure/Mods/"):
		dir.open(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS))
		dir.make_dir_recursive("/New DEV/Foxy Adventure/Mods/")
	if dir.open(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/New DEV/Foxy Adventure/Mods/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.get_extension() == "cfg":
					var tmp = {}
					cfg.load(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/New DEV/Foxy Adventure/Mods/" + file_name)
					tmp["name"] = cfg.get_value("mod_info", "name","name")
					tmp["author"] = cfg.get_value("mod_info", "author", "author")
					tmp["description"] = cfg.get_value("mod_info", "description")
					tmp["pck_files"] = cfg.get_value("mod_info", "pck_files")
					tmp["enabled"] = "True" #cfg.get_value("mod_info", "enabled", "True")
					tmp["sdk_version"] = cfg.get_value("sdk_info", "version")
					tmp["main_script_file"] = cfg.get_value("mod_info", "main_script_file")
					cfg.save(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/New DEV/Foxy Adventure/Mods/" + file_name)
					modifications[file_name.get_basename()] = tmp
			file_name = dir.get_next()
		print(modifications)
	else:
		print("An error occurred when trying to access the path.")
	print(modifications)

func set_modification_enable(m_name:String, enable:bool):
	var mod = modifications[m_name]
	mod["enabled"] = enable
	modifications[m_name]
	cfile.load(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/New DEV/Foxy Adventure/Mods/" + m_name + ".cfg")
	cfile.set_value("mod_info", "enabled", str(enable))
	cfile.save(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/New DEV/Foxy Adventure/Mods/" + m_name + ".cfg")
#	print(modifications)

func load_modification(mod_name):
	var mod = modifications[mod_name]
	print(mod)
	if mod["enabled"] == "True":
		print(mod["sdk_version"])
		print(str(supported_sdk_versions.has(int(mod["sdk_version"]))))
		if supported_sdk_versions.has(int(mod["sdk_version"])):
			for i in mod["pck_files"]:
				ProjectSettings.load_resource_pack(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/New DEV/Foxy Adventure/Mods/" + i)
			var main_script = load(mod["main_script_file"]).new()
			print("Loading mod")
			main_script.init_mod()
		else:
			print(mod["name"] + " - " + tr("KEY_TEXT_MODIFICATION_UNSUPPORTED_SDK"))
			OS.alert(mod["name"] + " - " + tr("KEY_TEXT_MODIFICATION_UNSUPPORTED_SDK"), tr("KEY_TEXT_WARNING"))

func load_stage_from_editor(stage_name:String, character:String):
	pass





#
#func get_used_license_keys():
#	var keys = []
#	return keys
#
#func get_unused_license_keys():
#	var keys = []
#	return keys
