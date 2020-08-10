tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton('EngineLogger', 'res://addons/consolelogger/consoleloggeer.gd')


func _exit_tree():
	remove_autoload_singleton('EngineLogger')
