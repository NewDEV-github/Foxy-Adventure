tool
extends EditorPlugin


func _enter_tree() -> void:
	Globals.DiscordRPC.new().RPCDevelopment()

func _exit_tree() -> void:
	Globals.DiscordRPC.new().RPCKill()
