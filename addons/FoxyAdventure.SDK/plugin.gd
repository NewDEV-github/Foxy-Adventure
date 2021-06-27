tool
extends EditorPlugin
var file = File.new()

func _enter_tree():
	if not file.file_exists("res://Scripts/Globals.gd"):
		add_autoload_singleton("Globals", "res://addons/FoxyAdventure.SDK/Autoloads/Scripts/Globals.gd")

func _exit_tree():
	if not file.file_exists("res://Scripts/Globals.gd"):
		remove_autoload_singleton("Globals")
