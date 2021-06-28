extends Panel


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var Editor = preload("res://Editor/Editor.gd").new()
onready var file_menu = $Container/File.get_popup()
onready var audio_menu = $Container/Audio.get_popup()
onready var bg_menu = $Container/Bg.get_popup()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg_menu.connect("id_pressed", self, "bg_menu_selected")
	file_menu.connect("id_pressed", self, "file_menu_selected")
	audio_menu.connect("id_pressed", self, "audio_menu_selected")

func bg_menu_selected(id:int):
	pass

func file_menu_selected(id:int):
	if id == 0:
		$NewFile.popup_centered()
	if id == 1:
		$FileLoadPopup.popup_centered()
	if id == 2:
		Editor.save_level()

func audio_menu_selected(id:int):
	pass
