extends Node
class_name FoxyAdventureSDK
const Lifes = preload("res://addons/FoxyAdventure.SDK/Core/Lifes.gd")
const Coins = preload("res://addons/FoxyAdventure.SDK/Core/Coins.gd")
const Worlds = preload("res://addons/FoxyAdventure.SDK/Core/Worlds.gd")
const Characters = preload("res://addons/FoxyAdventure.SDK/Core/Characters.gd")
var _cfg = ConfigFile.new()
func get_version():
	_cfg.open("res://addons/FoxyAdventure.SDK/config.cfg")
	return _cfg.get_value('information', 'version')
func get_version_string():
	_cfg.open("res://addons/FoxyAdventure.SDK/config.cfg")
	return _cfg.get_value('information', 'version_string')
