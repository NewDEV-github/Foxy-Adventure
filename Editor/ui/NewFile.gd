extends WindowDialog


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"



func _on_Button_pressed() -> void:
	if not $LineEdit.text == "":
		Globals.level_name = $LineEdit.text
		preload("res://Editor/Editor.gd").new().clear_all()
		get_tree().change_scene("res://Editor/Editor.tscn")
