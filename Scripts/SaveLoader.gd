extends Panel
export (bool) var tooltip_enabled = false
var save_file_names = []
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var disabled_saves = []
func show_slider():
	$HBoxContainer/VSlider.self_modulate = Color(255, 255, 255, 255)

func hide_slider():
	$HBoxContainer/VSlider.self_modulate = Color(255, 255, 255, 0)

signal no_saves_found
var cfg = ConfigFile.new()
func _ready() -> void:
	hide_slider()
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
						cfg.load(OS.get_user_data_dir() + "/" + file_name.get_file())
						print(OS.get_user_data_dir() + "/" + file_name.get_file())
						var save_char = cfg.get_value("save", "character")
						print(Globals.new_characters.values())
						print(save_char)
						if not Globals.new_characters.values().has(save_char):
							disabled_saves.append(save_name)
							print(disabled_saves)
						save_file_names.append(save_name)
			file_name = dir.get_next()
	else:
		
		print("An error occurred when trying to access the path.")
	if save_file_names.size() == 0:
		emit_signal("no_saves_found")
	else:
		for i in save_file_names:
			$HBoxContainer/ScrollContainer/ItemList.add_item(i)
			var item_id = $HBoxContainer/ScrollContainer/ItemList.get_item_count() -1
			$HBoxContainer/ScrollContainer/ItemList.set_item_tooltip_enabled(item_id, tooltip_enabled)
			if disabled_saves.has(i):
				
				$HBoxContainer/ScrollContainer/ItemList.set_item_disabled(item_id, true)
		yield(get_tree(), "idle_frame")
		var scb = $HBoxContainer/ScrollContainer.get_v_scrollbar()
#		print("MS: " + str(scb.max_value))
		if scb.max_value >= $HBoxContainer/ScrollContainer.rect_size.y:
			show_slider()
			$HBoxContainer/VSlider.max_value = scb.max_value - $HBoxContainer/ScrollContainer.rect_size.y
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
#	print('save id:' + str(index))


func _on_Cancel_pressed():
	hide()


func _on_DelSave_pressed():
	$ConfirmationDialog.popup_centered()


func _on_RunSave_pressed():
	var save_name = $HBoxContainer/ScrollContainer/ItemList.get_item_text(current_item_index)
	Globals.load_level(str(save_name))


func _on_ConfirmationDialog_confirmed():
	Globals.delete_save($HBoxContainer/ScrollContainer/ItemList.get_item_text(current_item_index))
	$HBoxContainer/ScrollContainer/ItemList.clear()
	save_file_names.clear()
	_ready()

func _on_ItemList_nothing_selected():
	$buttons/DelSave.disabled = true
	$buttons/RunSave.disabled = true


func _on_VSlider_value_changed(value):
	print(str(value))
#	print(str(value - $HBoxContainer/ScrollContainer.rect_size.y))
	$HBoxContainer/ScrollContainer.scroll_vertical = value
