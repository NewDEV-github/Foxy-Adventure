tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("Globals", "res://addons/FoxyAdventure.SDK/Autoloads/Scripts/Globals.gd")

func _exit_tree():
	remove_autoload_singleton("Globals")
