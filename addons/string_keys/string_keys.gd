tool
extends EditorPlugin

var dock

func _enter_tree():
	dock = preload("res://addons/string_keys/string_keys_dock.tscn").instance()
	dock.plugin = self
	add_control_to_dock(DOCK_SLOT_RIGHT_UR, dock)

func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()
