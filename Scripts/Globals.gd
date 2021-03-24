extends Node
#var project_root_dir = get_project_root_dir()
var all_achievements = [
	"I'm not toxic",
	"Up to five times",
        "Amateur sewage purifier",
        "Advanced sewage purifier",
        "Money collector",
        "Rich man",
        "Like a cat",
        "Like a cat, but... Better"
]
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
var version_string:String = "alpha"
var version_commit:String = "unknown"
var current_save_name = ""
var coins = 0
var lives = 5
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

func _ready():
#	execute_debugging_tools()
#	print("Project root dir is at: " + project_root_dir)
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
	if not file.file_exists("user://achievements.cfg"):
		generate_achievements_file()
	emit_signal("loaded")
func get_project_root_dir():
	return "res://".get_base_dir()


func set_variable(variable, value):
	set(variable, value)
func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_CRASH:
		OS.alert("App crashed!", "Error!")
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
	BackgroundLoad.play_start_transition = true
	BackgroundLoad.load_scene(loaded_stage)
func game_over():
	if lives != 1:
		get_tree().reload_current_scene()
		lives -= 1
	elif lives == 1:
		get_tree().change_scene("res://Scenes/GameOver.tscn")
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
	not_done_achievements.remove(not_done_achievements.find(achievement_name))
	done_achievements.append(achievement_name)
	generate_achievements_file()
