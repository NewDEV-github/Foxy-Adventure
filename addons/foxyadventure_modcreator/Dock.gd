tool
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
	cfg.set_value("mod_info", "main_script_file", $VBoxContainer/main_script_file.text)
	print("Generating " + "res://" + mod_name.to_lower().replace(' ', '_') + ".cfg" + "...")
	cfg.save("res://" + mod_name.to_lower().replace(' ', '_') + ".cfg")
	var file = File.new()
	file.open("user://FoxyAdventureModCreator.temp.cfg", File.WRITE)
	file.store_line(mod_name.to_lower().replace(' ', '_') + ".cfg")
	file.close()
