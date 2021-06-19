extends Node

var gdsdk_enabled = true
signal scoredatarecived
var fallen_into_toxins = 0
signal achivement_done(achivement)
var user_data = {}
var all_achievements = [
	"I'm not toxic",#done
	"Up to five times",#done
	"Amateur sewage purifier",#done
	"Advanced sewage purifier",#done
	"Money collector",#done
	"Rich man",#done
	"Like a cat",#done
	"Like a cat, but... Better",#done
]
var discord_sdk_enabled = false
var done_achievements = []
var not_done_achievements = all_achievements
var achievements_desc = {
	"I'm not toxic": "Don't touch the toxics in 1st stage",
	"Up to five times": "Lose all 5 lives",
	"Amateur sewage purifier": "Fall into toxins 5 times",
	"Advanced sewage purifier": "Fall into toxins 15 times",
	"Money collector": "Collect 50 coins",
	"Rich man": "Collect 100 coins",
	"Like a cat": "Get 9 lifes in game",
	"Like a cat, but... Better": "Get more than 9 lives in game",
}
var stage_list = {
	"0": "res://Scenes/Stages/poziom_1.tscn",
	"1": "res://Scenes/Stages/poziom_2.tscn",
	"2": "res://Scenes/Stages/poziom_3.tscn",
	"3": "res://Scenes/Stages/poziom_4.tscn",
	"4": "res://Scenes/Stages/poziom_5.tscn",
	"5": "res://Scenes/Stages/poziom_6.tscn",
}
var stage_names:Dictionary = {
	"0": "Laboratory",
	"1": "Laboratory",
	"2": "Laboratory",
	"3": "Laboratory",
	"4": "Laboratory",
	"5": "Laboratory",
}
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
var new_characters:Array = [
	"Tails",
]

func construct_game_version():
	var text = "Support: support@new-dev.ml\n%s\nCopyright 2020 - %s, New DEV" % [str(ProjectSettings.get_setting("application/config/name")), OS.get_date().year]
	return text
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
	OS.window_borderless = false
	install_base_path = OS.get_executable_path().get_base_dir() + "/"
	print("Installed at: " + install_base_path)
	var cfg = ConfigFile.new()
	var dir = Directory.new()
	if dir.open(install_base_path + 'translations') == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.get_extension() == "pck":
					ProjectSettings.load_resource_pack(install_base_path + 'translations/' + file_name.get_file())
					var tra = load("res://translations/" + file_name.get_file().get_basename())
					print("Found translation: " + "res://translations/" + file_name.get_file().get_basename())
					TranslationServer.add_translation(tra)
			file_name = dir.get_next()
	print(arguments)
var dlcs:Array = [
	
]
var worlds:Array = [
	
]
var cworlds:Array = [
	
]
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
func enable_discord_sdk(en):
	discord_sdk_enabled = en
	var cfg = ConfigFile.new()
	cfg.load("user://settings.cfg")
	cfg.set_value('Game', 'discord_sdk_enabled', str(en))
	cfg.save("user://settings.cfg")
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
	if not cworlds.has(world_name):
		cworlds.append(world_name)
	else:
		OS.alert("Stage named " + world_name + "\nis already imported into the game.", "Oops!")
func add_custom_world_scan_path(path:String):
	levels_scan_path.append(path)

func add_life():
	lives += 1
	if lives == 9:
		set_achievement_done("Like a cat")
	elif lives >= 9:
		set_achievement_done("Like a cat, but... Better")

func add_coin(anmount, upload_score=false):
	if user_data.has("localid"):
#		print(user_data["localid"])
		Api.update_score(user_data["localid"], anmount, upload_score)
	coins += anmount
	
#	print(str(int(coins) % 100))
	if int(coins) % 100 == 0:
		add_life()
	if coins == 50:
		set_achievement_done("Money collector")
	elif coins == 100:
		set_achievement_done("Rich man")

func felt_into_toxine():
	fallen_into_toxins += 1
	if fallen_into_toxins == 5:
		set_achievement_done("Amateur sewage purifier")
	elif fallen_into_toxins == 15:
		set_achievement_done("Advanced sewage purifier")

	emit_signal("scoredatarecived")

func _ready():
	OS.execute(install_base_path + "send_log/send_log", [])
#	OS.execute(OS.get_executable_path(), ["--send-log"], false)
#	OS.shell_open(OS.get_executable_path() + " --send-log")
#	get_tree().quit()
	if arguments.has("send-log"):
		Api.send_debug_log_to_database()
		yield(Api, "recived_log_id")
		OS.alert("Your log was sent\n\nHere is log id: (0)" + str(Api.tmp_log_id))
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
	if not file.file_exists("user://achievements.cfg"):
		generate_achievements_file()
	scan_and_load_modifications_cfg()
	for i in modifications:
		load_modification(i)
	emit_signal("loaded")
func get_project_root_dir():
	return "res://".get_base_dir()


func set_variable(variable, value):
	set(variable, value)
func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_CRASH:
		OS.alert("App crashed!", "Error!")
#		OS.shell_open(OS.get_executable_path() + " --send-log")
		OS.execute(OS.get_executable_path(), ["--send-log"], false)
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
		set_achievement_done("Up to five times")
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
					tmp["name"] = cfg.get_value("mod_info", "name")
					tmp["author"] = cfg.get_value("mod_info", "author")
					tmp["description"] = cfg.get_value("mod_info", "description")
					tmp["pck_files"] = cfg.get_value("mod_info", "pck_files")
					tmp["enabled"] = cfg.get_value("mod_info", "enabled")
					tmp["main_script_file"] = cfg.get_value("mod_info", "main_script_file")
					cfg.save(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/New DEV/Foxy Adventure/Mods/" + file_name)
					modifications[file_name.get_basename()] = tmp
			file_name = dir.get_next()
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
	if mod["enabled"] == "True":
		for i in mod["pck_files"]:
			ProjectSettings.load_resource_pack(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/New DEV/Foxy Adventure/Mods/" + i)
		var main_script = load(mod["main_script_file"]).new()
		main_script.add_characters()
		main_script.add_stages()
