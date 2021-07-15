extends Panel
export (bool) var tooltip_enabled = false
var save_file_names = []
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
signal no_saves_found
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globals.arguments.has("locale"):
		print("Setting locale to: " + Globals.arguments["locale"])
		TranslationServer.set_locale(Globals.arguments["locale"])
	$buttons/DelSave.disabled = true
	$buttons/RunSave.disabled = true
#	popup()
	var dir = Directory.new()
	if dir.open("user://") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				if file_name.get_extension() == "cfg" and file_name.begins_with("save_"):
					var save_name = get_save_name(file_name.get_basename())
					if not save_name == "":
						save_file_names.append(save_name)
			file_name = dir.get_next()
	else:
		
		print("An error occurred when trying to access the path.")
	if save_file_names.size() == 0:
		emit_signal("no_saves_found")
	else:
		for i in save_file_names:
			$ItemList.add_item(i)
			var item_id = $ItemList.get_item_count() -1
			$ItemList.set_item_tooltip_enabled(item_id, tooltip_enabled)
func get_save_name(file_name:String):
	return file_name.trim_prefix("save_")
#	var regex = RegEx.new()
#	regex.compile("save_(\\s+).cfg")
#	var result = regex.search(file_name)
#	if result:
#		return result.get_string()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
var current_item_index

func _on_ItemList_item_selected(index: int) -> void:
	$buttons/DelSave.disabled = false
	$buttons/RunSave.disabled = false
	current_item_index = index


func _on_Cancel_pressed():
	hide()


func _on_DelSave_pressed():
	$ConfirmationDialog.popup_centered()


func _on_RunSave_pressed():
	var save_name = $ItemList.get_item_text(current_item_index)
	Globals.load_level(str(save_name))


func _on_ConfirmationDialog_confirmed():
	Globals.delete_save($ItemList.get_item_text(current_item_index))
	$ItemList.clear()
	save_file_names.clear()
	_ready()

func _on_ItemList_nothing_selected():
	$buttons/DelSave.disabled = true
	$buttons/RunSave.disabled = true
