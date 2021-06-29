extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var Editor = preload("res://Editor/Editor.gd").new()
var stage_path
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Editor.connect("stage_preloaded", self, "editor_stage_preloaded")
	$FileLoadPopup.connect("stage_file_selected", self, "file_sel")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_New_pressed() -> void:
	$NewFile.popup_centered()

func file_sel(path):
	Editor.preload_stage(path)
func _on_Load_pressed() -> void:
	$FileLoadPopup.show_popup()
func editor_stage_preloaded():
	get_tree().change_scene("res://Editor/Editor.tscn")
