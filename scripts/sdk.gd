extends Node
class_name FoxyAdventureSDK
var Lifes
var Coins
var Worlds
var Achievements
var Characters
var _cfg = ConfigFile.new()
var _initialized = false
const debug_text = "FoxyAdventure.SDK"
var _debugger_initialized = false
enum INIT_FLAGS {
	INIT_NORMAL = 0,
	INIT_DEBUG = 1
}
func get_version():
	if _initialized == true:
		_cfg.load("res://addons/FoxyAdventure.SDK/config.cfg")
		return _cfg.get_value('information', 'version')
	else:
		print("Please, initialize SDK first, before using that function")
func get_version_string():
	if _initialized == true:
		_cfg.load("res://addons/FoxyAdventure.SDK/config.cfg")
		return _cfg.get_value('information', 'version_string')
	else:
		print("Please, initialize SDK first, before using that function")
var ret_init_flag = 0
func init(init_flag:int):
	print("[%s.Core] Initializing Core..."  % [debug_text])
	match init_flag:
		0:
			pass
		1:
			_init_debugger()
	print("[%s.Core] Core initialized successfully..."  % [debug_text])
	_initialized = true
	print("[%s.Core] SDK version is: %s [%s]"  % [debug_text, get_version_string(), get_version()])
func _notification(what):
	if what == NOTIFICATION_CRASH:
		if _debugger_initialized == true:
			throw_crash("Main")


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
enum SCENES {
	MAIN_MENU = 0,
	GAME_OVER = 1,
	CREDITS = 2
}

func change_scene_to(scene:int):
	if _initialized == true:
		match scene:
			0:
				get_tree().change_scene("res://Scenes/Menu.tscn")
			1:
				get_tree().change_scene("res://Scenes/GameOver.tscn")
			2:
				get_tree().change_scene("res://Scenes/Credits.tscn")
	else:
		print("Please, initialize SDK first, before using that function")

###
