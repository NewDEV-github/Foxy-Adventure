tool
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sdk = preload("res://bin/sdk/sdk.gdns").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var f = File.new()
	f.open("res://version.dat", File.READ)
	$VBoxContainer/game_versions.text = f.get_line()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Generate_pressed():
	var cfg = ConfigFile.new()
	var mod_name = $VBoxContainer/name.text
	cfg.load("res://" + mod_name.to_lower().replace(' ', '_') + ".cfg")
	cfg.set_value("mod_info", "author", $VBoxContainer/author.text)
	cfg.set_value("mod_info", "name", mod_name)
	cfg.set_value("mod_info", "description", $VBoxContainer/description.text)
	if not $VBoxContainer/pck_files.text.length() == 0:
		cfg.set_value("mod_info", "pck_files", $VBoxContainer/pck_files.text)
	cfg.set_value("mod_info", 'enabled', str(false))
	cfg.set_value("mod_info", "main_script_file", $VBoxContainer/HBoxContainer/main_script_file.text)
	cfg.set_value("game_info", "supported_versions", $VBoxContainer/game_versions.text)
	cfg.set_value("game_info", "support_lover_versions", str($VBoxContainer/l_v_support.pressed))
	cfg.set_value("game_info", "support_higher_versions", str($VBoxContainer/h_v_support.pressed))
	cfg.set_value("sdk_info", "version", sdk.get_version())
	print("Generating " + "res://" + mod_name.to_lower().replace(' ', '_') + ".cfg" + "...")
	cfg.save("res://" + mod_name.to_lower().replace(' ', '_') + ".cfg")
	var file = File.new()
	file.open("user://FoxyAdventureModCreator.temp.cfg", File.WRITE)
	file.store_line(mod_name.to_lower().replace(' ', '_') + ".cfg")
	print("Generated!")
	file.close()


func _on_SelectMainScriptFile_pressed():
	$GdDialog.popup_centered()


func _on_GdDialog_file_selected(path):
	$VBoxContainer/HBoxContainer/main_script_file.text = path
