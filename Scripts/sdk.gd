extends Node
class_name FoxyAdventureSDK
###104
var Lifes
var Coins
var Worlds
var Achievements
var Characters
var _cfg = ConfigFile.new()
var _initialized = false
const debug_text = "FoxyAdventure.SDK"
var _debugger_initialized = false
var version_script
enum INIT_FLAGS {
	INIT_NORMAL = 0,
	INIT_DEBUG = 1
}
func get_changelog():
	if _initialized == true:
		return version_script.changelog
	else:
		print("Please, initialize SDK first, before using that function")
func get_version():
	if _initialized == true:
		return version_script.version
	else:
		print("Please, initialize SDK first, before using that function")
func get_version_string():
	if _initialized == true:
		return version_script.version_string
	else:
		print("Please, initialize SDK first, before using that function")
var ret_init_flag = 0
func init(init_flag:int):
	print("[%s.Core] Initializing Core..."  % [debug_text])
	match init_flag:
		0:
			_test_files()
			version_script = load("res://addons/FoxyAdventure.SDK/Core/Core.Version.gd").new()
		1:
			_init_debugger()
			_test_files()
			version_script = load("res://addons/FoxyAdventure.SDK/Core/Core.Version.gd").new()
	print("[%s.Core] Core initialized successfully..."  % [debug_text])
	_initialized = true
	print("[%s.Core] SDK version is: %s [%s]"  % [debug_text, get_version_string(), get_version()])
func _notification(what):
	if what == NOTIFICATION_CRASH:
		if _debugger_initialized == true:
			throw_crash("Main")

func _test_files():
	var dir = Directory.new()
	var scan_paths = ["res://addons/FoxyAdventure.SDK/Core/", "res://addons/FoxyAdventure.SDK/Autoloads/Scenes/", "res://addons/FoxyAdventure.SDK/Autoloads/Scripts/"]
	for i in scan_paths:
		dir.open(i)
		dir.list_dir_begin()
		var fn = dir.get_next()
		while fn != "":
			if not dir.current_is_dir():
				if _debugger_initialized:
					throw_warning("Main.FileSystemCheck", "Found file: " + i + fn.get_file())
			fn = dir.get_next()


### DEBUGGER

var _dt = "FoxyAdventure.SDK"
var _error_message = "[%s.Debugger] Error at: " % [_dt]
var _crash_message = "[%s.Debugger] Crash at: " % [_dt]
var _warning_message = "[%s.Debugger] Warning at: " % [_dt]
var _g = Globals
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _init_debugger():
	print("[%s.Debugger] Initializing Debugger..."  % [debug_text])
	_error_message = "[%s.Debugger] Error at: " % [debug_text]
	_crash_message = "[%s.Debugger] Crash at: " % [debug_text]
	_warning_message = "[%s.Debugger] Warning at: " % [debug_text]
	if _g == null:
#		print(_crash_message + "Globals - Singleton doesn't exist")
		printerr(_crash_message  + "Globals - Singleton doesn't exist")
	print("[%s.Debugger] Debugger initialized successfully..."  % [debug_text])
	_debugger_initialized = true

func throw_error(where:String, what:String = ""):
	if _debugger_initialized:
		var text
		if not what == "":
			text = _error_message + where + " - " + what
		else:
			text = _error_message + where
	#	print(text)
		printerr(text)

func throw_crash(where:String, what:String = ""):
	if _debugger_initialized:
		var text
		if not what == "":
			text = _crash_message + where + " - " + what
		else:
			text = _crash_message + where
	#	print(text)
		printerr(text)

func throw_warning(where:String, what:String = ""):
	if _debugger_initialized:
		var text
		if not what == "":
			text = _warning_message + where + " - " + what
		else:
			text = _warning_message + where
		print(text)

### Lifes

func add_lifes(anmount):
	if _initialized == true:
		Globals.add_life(anmount)
	else:
		print("Please, initialize SDK first, before using that function")

func remove_lifes(anmount):
	if _initialized == true:
		Globals.remove_lifes(anmount)
	else:
		print("Please, initialize SDK first, before using that function")

func set_lifes(anmount):
	if _initialized == true:
		Globals.set_lifes(anmount)
	else:
		print("Please, initialize SDK first, before using that function")

func get_lifes():
	if _initialized == true:
		return Globals.lives
	else:
		print("Please, initialize SDK first, before using that function")
### Worlds

func register_world(world_name:String, path:String):
	throw_warning("Worlds", "Registering world: " + world_name + " at path: " + path)
	if _initialized == true:
		Globals.add_world(world_name, path)
	else:
		print("Please, initialize SDK first, before using that function")

### Console

func add_command(name, target, target_name=null):
	if _initialized == true:
		var file = File.new()
		if file.file_exists("res://addons/quentincaffeino-console/src/Command/CommandService.gd"):
			throw_warning("Console", "Registering command: " + name + "for target: " + target)
	#		Console.addCommand(name, target, target_name)
		else:
			throw_error("Console", "That command - 'add_command' will work only when modification is runned inside Foxy Adventure!")
	else:
		print("Please, initialize SDK first, before using that function")
### Coins

func add_coins(anmount):
	if _initialized == true:
		Globals.add_coin(anmount)
	else:
		print("Please, initialize SDK first, before using that function")
func remove_coins(anmount):
	if _initialized == true:
		Globals.remove_coins(anmount)
	else:
		print("Please, initialize SDK first, before using that function")
func set_coins(anmount):
	if _initialized == true:
		Globals.set_coins(anmount)
	else:
		print("Please, initialize SDK first, before using that function")
func get_coins():
	if _initialized == true:
		return Globals.coins
	else:
		print("Please, initialize SDK first, before using that function")
### Characters
func get_current_character_path():
	if _initialized == true:
		return Globals.character_path
	else:
		print("Please, initialize SDK first, before using that function")

func set_current_character_path(path):
	if _initialized == true:
		Globals.character_path = path
	else:
		print("Please, initialize SDK first, before using that function")

func get_current_character_instance():
	if _initialized == true:
		var _n = load(str(Globals.character_path)).instance()
	else:
		print("Please, initialize SDK first, before using that function")

func get_current_character_name():
	if _initialized == true:
		var _n = load(str(Globals.character_path)).instance()
		return _n.name
	else:
		print("Please, initialize SDK first, before using that function")

func register_character(character_name:String, path:String):
	throw_warning("Characters", "Registering character: " + character_name + " at path: " + path)
	if _initialized == true:
		Globals.add_character(character_name, path)
	else:
		print("Please, initialize SDK first, before using that function")

### Discord SDK

func run_rpc(stage:String, character:String):
	if _initialized == true:
		DiscordSDK._ready()
		DiscordSDK.run_rpc(false, stage, character)
	else:
		print("Please, initialize SDK first, before using that function")

### Achievements

func add_achievement(name, desc):
	throw_warning("Achievements", "Registering achievement: " + name)
	if _initialized == true:
		Globals.all_achievements.append(name)
		Globals.achievements_desc[name] = desc
	else:
		print("Please, initialize SDK first, before using that function")

func add_achievement_requirement(name, variable, value):
	throw_warning("Achievements", "Registering requirements for achievement: " + name)
	if _initialized == true:
		Globals.custom_achievements_requirements[name][variable] = value
	else:
		print("Please, initialize SDK first, before using that function")

### Scenes
const SCENES = {
	###105
	STAGE_1 = "res://Scenes/Stages/poziom_1.tscn",
	STAGE_2 = "res://Scenes/Stages/poziom_2.tscn",
	STAGE_3 = "res://Scenes/Stages/poziom_3.tscn",
	STAGE_4 = "res://Scenes/Stages/poziom_4.tscn",
	STAGE_5 = "res://Scenes/Stages/poziom_5.tscn",
	STAGE_6 = "res://Scenes/Stages/poziom_6.tscn",
	###104
	MAIN_MENU = "res://Scenes/Menu.tscn",
	GAME_OVER = "res://Scenes/GameOver.tscn",
	CREDITS = "res://Scenes/Credits.tscn",
}

func change_scene_to(scene:String):
	if _initialized == true:
		get_tree().change_scene(scene)
		throw_warning("Core", "Changing scene to: " + scene)
	else:
		print("Please, initialize SDK first, before using that function")

### Loading Screen

func add_hint_on_loading_screen(text):
	if _initialized == true:
		BackgroundLoad.get_node("bgload").add_hint(text)
	else:
		print("Please, initialize SDK first, before using that function")

### Main Menu

func set_version_label_menu_bbcode_text(text:String):
	Globals.game_version_text = text
	Globals.construct_game_version()

func add_custom_menu_bg(path:String):
	if _initialized == true:
		Globals.custom_menu_bg = path
	else:
		print("Please, initialize SDK first, before using that function")

func add_custom_menu_audio(path:String):
	if _initialized == true:
		Globals.custom_menu_audio = path
	else:
		print("Please, initialize SDK first, before using that function")

###105
func change_stage(stage_id:String):
	if _initialized == true:
		Globals.change_stage(stage_id)
	else:
		print("Please, initialize SDK first, before using that function")
func add_stage_to_list(stage_path:String, stage_name:String):
	if _initialized == true:
		Globals.add_stage_to_list(stage_path, stage_name)
	else:
		print("Please, initialize SDK first, before using that function")
func replace_stage_in_list(id:String, stage_path:String, stage_name:String):
	if _initialized == true:
		Globals.replace_stage_in_list(id, stage_path, stage_name)
	else:
		print("Please, initialize SDK first, before using that function")
func set_stage_list(list:Dictionary):
	if _initialized == true:
		Globals.set_stage_list(list)
	else:
		print("Please, initialize SDK first, before using that function")
func change_stage_to_next():
	if _initialized == true:
		Globals.change_stage_to_next()
	else:
		print("Please, initialize SDK first, before using that function")
func set_stage_name(id:String, stage_name:String):
	if _initialized == true:
		Globals.set_stage_name(id, stage_name)
	else:
		print("Please, initialize SDK first, before using that function")
