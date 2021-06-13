tool
extends EditorPlugin
var export_plugin = TranslationsExport.new()

func _enter_tree():
	add_export_plugin(export_plugin)


func _exit_tree():
	remove_export_plugin(export_plugin)
