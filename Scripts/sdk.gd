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
	_cfg.open("res://addons/FoxyAdventure.SDK/config.cfg")
	return _cfg.get_value('information', 'version')
func get_version_string():
	_cfg.open("res://addons/FoxyAdventure.SDK/config.cfg")
	return _cfg.get_value('information', 'version_string')

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
	Globals.add_life(anmount)

func remove_lifes(anmount):
	Globals.remove_lifes(anmount)

func set_lifes(anmount):
	Globals.set_lifes(anmount)

func get_lifes():
	return Globals.lives

### Worlds

func register_world(world_name:String, path:String):
	throw_warning("Worlds", "Registering world: " + world_name + "at path: " + path)
	Globals.add_world(world_name, path)

### Console

func add_command(name, target, target_name=null):
	var file = File.new()
	if file.file_exists("res://addons/quentincaffeino-console/src/Command/CommandService.gd"):
		throw_warning("Console", "Registering command: " + name + "for target: " + target)
#		Console.addCommand(name, target, target_name)
	else:
		throw_error("Console", "That command - 'add_command' will work only when modification is runned inside Foxy Adventure!")

### Coins

func add_coins(anmount):
	Globals.add_coin(anmount)

func remove_coins(anmount):
	Globals.remove_coins(anmount)

func set_coins(anmount):
	Globals.set_coins(anmount)

func get_coins():
	return Globals.coins
	
### Characters

func register_character(character_name:String, path:String):
	throw_warning("Characters", "Registering world: " + character_name + " at path: " + path)
	Globals.add_character(character_name, path)

### Achievements

func add_achievement(name, desc):
	throw_warning("Achievements", "Registering achievement: " + name)
	Globals.all_achievements.append(name)
	Globals.achievements_desc[name] = desc

func add_achievement_requirement(name, variable, value):
	throw_warning("Achievements", "Registering requirements for achievement: " + name)
	Globals.custom_achievements_requirements[name][variable] = value
