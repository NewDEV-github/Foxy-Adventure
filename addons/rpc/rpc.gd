tool
extends EditorPlugin
var globals = preload("res://Scripts/Globals.gd").new()

func _enter_tree() -> void:
	globals.RPCDevelopment()

func _exit_tree() -> void:
	globals.RPCKill()
