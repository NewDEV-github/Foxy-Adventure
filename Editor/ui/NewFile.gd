extends WindowDialog


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"



func _on_Button_pressed() -> void:
	if not $VBoxContainer/LevelName.text == "":
		Globals.level_name_org = $VBoxContainer/LevelName.text
		Globals.level_name = $VBoxContainer/LevelName.text.replace(' ', '_').replace("'", '_').replace('"', '_').replace('.', '_').replace('/', '_').replace('\\', '_')
		Globals.level_author = $VBoxContainer/LevelAuthor.text
		Globals.level_description = $VBoxContainer/LevelDescription.text
		Globals.level_version = $VBoxContainer/LevelVersion.text
		$"../".Editor.clear_all()
		$"../".Editor.save_level()
		hide()
