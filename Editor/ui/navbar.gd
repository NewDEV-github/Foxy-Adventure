extends Panel

var audio_file_paths = {}
onready var Editor = $"../../Node2D"
onready var file_menu = $Container/File.get_popup()
onready var audio_menu = $Container/Audio.get_popup()
onready var bg_menu = $Container/Bg.get_popup()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh_bg_list()
	bg_menu.connect("id_pressed", self, "bg_menu_selected")
	file_menu.connect("id_pressed", self, "file_menu_selected")
	audio_menu.connect("id_pressed", self, "audio_menu_selected")
var bg_file_paths = {"Laboratory": 0}
func bg_menu_selected(id:int):
	if id == 0:
		$BackgroundPanel.popup_centered()
func set_status_label_text(text:String):
	$Container/StatusLabel.text = text
func file_menu_selected(id:int):
	print("sel: " + str(id))
	if id == 0:
		$ConfigurationMenu.popup_centered()
	if id == 1:
		$"../ProjectSelect".show()
	if id == 2:
		Editor.save_level()
	if id == 3:
		Editor.build_level()
	if id == 4:
		OS.shell_open(OS.get_user_data_dir() + "/level_data/" + Globals.level_name + "/")
	if id == 5:
		$OptionsMenu.popup_centered()
	if id == 6:
		get_tree().change_scene("res://Scenes/Menu.tscn")
func add_bg_to_list(name:String, file_path:String):
	$BackgroundPanel/VBoxContainer/BgList.add_item(name)
	bg_file_paths[name] = file_path
	refresh_bg_list()
func audio_menu_selected(id:int):
	if id == 0:
		$AudioDialog/ItemListAudio.clear()
		for i in EditorGlobals.audios:
			$AudioDialog/ItemListAudio.add_item(str(EditorGlobals.audios[i]).get_file())
		$AudioDialog.popup_centered()
func refresh_bg_list():
	$BackgroundPanel/VBoxContainer/BgList.clear()
	for i in bg_file_paths:
		$BackgroundPanel/VBoxContainer/BgList.add_item(i)


func _on_BgList_item_activated(index):
	Editor.add_bg(bg_file_paths[$BackgroundPanel/VBoxContainer/BgList.get_item_text(index)])


func _on_AudioPopup_file_selected(path):
	audio_file_paths[str(path).get_file()] = str(path)
	$AudioDialog/ItemListAudio.add_item(str(path).get_file())

func popup_new_file_window():
	$ConfigurationMenu.popup_centered()

func popup_options_window():
	$OptionsMenu.popup_centered()

func _on_FileLoadPopup_dir_selected(dir):
	Editor.load_stage(dir)

var _tmp_aufio_file_name = "null"
var _tmp_aufio_file_id = -1
var _prev_selected_audio_item_id
func _on_DeleteAudio_pressed():
	$AudioDialog/ItemListAudio.remove_item(_tmp_aufio_file_id)
	audio_file_paths[_tmp_aufio_file_name] = null


func _on_UseAudio_pressed():
	if not _tmp_aufio_file_name == "null":
		Editor.add_audio(_tmp_aufio_file_id)
		$AudioDialog/ItemListAudio.set_item_text(_tmp_aufio_file_id, $AudioDialog/ItemListAudio.get_item_text(_tmp_aufio_file_id) + " (currently used)")
		$AudioDialog/ItemListAudio.set_item_text(_prev_selected_audio_item_id, $AudioDialog/ItemListAudio.get_item_text(_prev_selected_audio_item_id).rstrip(" (currently used)"))
func _on_ItemListAudio_item_selected(index):
	
	var item_text = $AudioDialog/ItemListAudio.get_item_text(index)
	if $AudioDialog/ItemListAudio.get_item_text(index).ends_with(" (currently used)"):
		_tmp_aufio_file_name = item_text.rstrip(" (currently used)")
	else:
		_tmp_aufio_file_name = item_text
	print("Selected: " + _tmp_aufio_file_name)
	_prev_selected_audio_item_id = _tmp_aufio_file_id
	_tmp_aufio_file_id = index


func _on_AddAudio_pressed():
	$AudioPopup.popup_centered()


func _on_ConfigurationMenu_mouse_entered():
	EditorGlobals.can_place_tiles = false


func _on_ConfigurationMenu_mouse_exited():
	EditorGlobals.can_place_tiles = true


func _on_OptionsMenu_mouse_entered():
	EditorGlobals.can_place_tiles = false


func _on_OptionsMenu_mouse_exited():
	EditorGlobals.can_place_tiles = true


func _on_FileLoadPopup_mouse_entered():
	EditorGlobals.can_place_tiles = false


func _on_FileLoadPopup_mouse_exited():
	EditorGlobals.can_place_tiles = true


func _on_File_mouse_entered():
	EditorGlobals.can_place_tiles = false


func _on_File_mouse_exited():
	EditorGlobals.can_place_tiles = true


func _on_Audio_mouse_entered():
	EditorGlobals.can_place_tiles = false


func _on_Audio_mouse_exited():
	EditorGlobals.can_place_tiles = true


func _on_Bg_mouse_entered():
	EditorGlobals.can_place_tiles = false


func _on_Bg_mouse_exited():
	EditorGlobals.can_place_tiles = true


func _on_BackgroundPanel_mouse_entered():
	EditorGlobals.can_place_tiles = false


func _on_BackgroundPanel_mouse_exited():
	EditorGlobals.can_place_tiles = true


func _on_AudioPopup_mouse_exited():
	EditorGlobals.can_place_tiles = true


func _on_AudioPopup_mouse_entered():
	EditorGlobals.can_place_tiles = false


func _on_AudioDialog_mouse_entered():
	EditorGlobals.can_place_tiles = false


func _on_AudioDialog_mouse_exited():
	EditorGlobals.can_place_tiles = true
