tool
extends EditorPlugin
var file = File.new()
var control
var export_plugin = FoxyAdventureMODCfgExport.new()
var dock = preload("res://addons/FoxyAdventure.SDK/Core/Dock.tscn").instance().get_node(".")
func _enter_tree():
	control = preload("res://addons/FoxyAdventure.SDK/Core/Panel.tscn").instance()
	if not Engine.has_singleton("Globals"):
		add_autoload_singleton("Globals", "res://addons/FoxyAdventure.SDK/Autoloads/Scripts/Globals.gd")
	if not Engine.has_singleton("DiscordSDK"):
		add_autoload_singleton("DiscordSDK", "res://addons/FoxyAdventure.SDK/Autoloads/Scripts/DiscordSDK.gd")
	add_control_to_bottom_panel(control, "Foxy Adventure SDK")
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BR, dock)
	add_export_plugin(export_plugin)

func _exit_tree():
	if Engine.has_singleton("Globals"):
		remove_autoload_singleton("Globals")
	if Engine.has_singleton("DiscordSDK"):
		remove_autoload_singleton("DiscordSDK")
	remove_control_from_bottom_panel(control)
	remove_control_from_docks(dock)
	remove_export_plugin(export_plugin)
