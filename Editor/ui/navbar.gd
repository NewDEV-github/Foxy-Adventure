extends Panel


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
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
var bg_file_paths = {"Laboratory": "res://Scenes/Stages/bg1.tscn"}
func bg_menu_selected(id:int):
	if id == 0:
		$BackgroundPanel.popup_centered()

func file_menu_selected(id:int):
	if id == 0:
		$ConfigurationMenu.popup_centered()
	if id == 1:
		$FileLoadPopup.popup_centered()
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
		$AudioPopup.popup_centered()
func refresh_bg_list():
	$BackgroundPanel/VBoxContainer/BgList.clear()
	for i in bg_file_paths:
		$BackgroundPanel/VBoxContainer/BgList.add_item(i)


func _on_BgList_item_activated(index):
	Editor.add_bg(bg_file_paths[$BackgroundPanel/VBoxContainer/BgList.get_item_text(index)])


func _on_AudioPopup_file_selected(path):
	Editor.add_audio_from_file(path)

func popup_new_file_window():
	$ConfigurationMenu.popup_centered()

func popup_options_window():
	$OptionsMenu.popup_centered()

func _on_FileLoadPopup_dir_selected(dir):
	Editor.load_stage(dir)
