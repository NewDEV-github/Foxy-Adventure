tool
extends EditorPlugin
var export_plugin = FoxyAdventureMODCfgExport.new()
var dock = preload("res://addons/foxyadventure_modcreator/Dock.tscn").instance().get_node(".")
func _enter_tree():
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BR, dock)
	add_export_plugin(export_plugin)


func _exit_tree():
	remove_control_from_docks(dock)
	remove_export_plugin(export_plugin)
