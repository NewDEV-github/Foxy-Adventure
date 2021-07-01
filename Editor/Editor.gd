
extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var bg_path = 'none'
onready var navbar = $"../CanvasLayer/navbar"
var modes = ["custom_audio", "custom_tiles", "custom_backgrounds", "scripts", "configuration", "finished"]
signal stage_preloaded
var audio_file_path:String = ""
var scripts:Array = []
var custom_tile_sets:Array = []
func preload_stage(path):
	load_stage(path)
	emit_signal("stage_preloaded")
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
func load_stage(path):
	navbar.set_status_label_text("Loading project from: " + path + "...")
	var cfg = ConfigFile.new()
	cfg.load(path + "/configuration/main.cfg")
	navbar.set_status_label_text("Clearing tree...")
	for i in $".".get_children():
		navbar.set_status_label_text("Removing: " + str(i) + "...")
		remove_child(i)
	navbar.set_status_label_text("Tree cleared")
	navbar.set_status_label_text("Setting up nodes...")
	for i in Array(cfg.get_value("nodes", ".")):
		print("Adding " + str(i) + " to scene...")
		navbar.set_status_label_text("Setting up: " + str(i) + "...")
		i.name = i.get_class()
		add_child(i)
	navbar.set_status_label_text("Nodes set up done")
	navbar.set_status_label_text("Gathering required information...")
	_tmp_audio_path = cfg.get_value("values_AudioStreamPlayer", "stream_path")
	Globals.level_author = cfg.get_value("info", "author")
	Globals.level_description = cfg.get_value("info", "description")
	Globals.level_version = cfg.get_value("info", "version")
	Globals.level_name = cfg.get_value("info", "name")
	navbar.audio_file_paths = cfg.get_value("data", "audio_file_paths")
	if cfg.get_value("data", "bg_path") != 'none':
		add_bg(cfg.get_value("data", "bg_path"))
	navbar.set_status_label_text("Project setup done")
#	$AudioStreamPlayer.autoplay = cfg.get_value("values_AudioStreamPlayer", "autoplay")
func _ready() -> void:
	config_dirs()
func config_dirs():
	var dir = Directory.new()
	var mode_num = 0
	var mode = modes[mode_num]
	navbar.set_status_label_text("Configuring directory:" + "...")
	if not dir.dir_exists("user://level_data/"):
		dir.make_dir("user://level_data/")
	if not dir.dir_exists("user://level_data/" + Globals.level_name):
		dir.open("user://level_data/")
		dir.make_dir(Globals.level_name)
	while not mode == "finished":
		dir.open("user://level_data/" + Globals.level_name)
		if not dir.dir_exists(mode):
			navbar.set_status_label_text("Configuring directory: " + mode + " because It doesn't exist...")
			dir.make_dir(mode)
		mode_num += 1
		mode = modes[mode_num]
func clear_all():
	if $TileMap:
		$TileMap.clear()
func add_bg(file_path:String):
	bg_path = "user://level_data/" + Globals.level_name + "/custom_backgrounds/" + file_path.get_file()
	var dir = Directory.new()
	dir.copy(file_path, bg_path)
	var n = load(bg_path).instance()
	add_child(n)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("paint_tile"):
		$TileMap.paint_tile(get_global_mouse_position(), 8)
func build_level():
	var cfg = ConfigFile.new()
	config_dirs()
	## FOR BUILDING ALL PATHS OF DEPENDENCIES NEEDS TO BE REDEFINED
	navbar.set_status_label_text("Reconfiguring paths for dependencies...")
	cfg.load("user://level_data/" + Globals.level_name + "/configuration/main.cfg")
	cfg.set_value("nodes", ".", $".".get_children())
	cfg.set_value("values_AudioStreamPlayer", "stream_path", _tmp_audio_path.replace("user://", "res://"))
	cfg.set_value("info", "author", Globals.level_author)
	cfg.set_value("info", "description", Globals.level_description)
	cfg.set_value("info", "version", Globals.level_version)
	cfg.set_value("info", "name", Globals.level_name)
	cfg.save("user://level_data/" + Globals.level_name + "/configuration/main.cfg")
	navbar.set_status_label_text("Done")
	var pck = PCKPacker.new()
	navbar.set_status_label_text("Creating PCK file...")
	pck.pck_start(Globals.level_path + Globals.level_name + ".pck")
	navbar.set_status_label_text("Created")
	var dir = Directory.new()
	#custom_audio
	var mode_num = 0
	var mode = modes[mode_num]
	navbar.set_status_label_text("Packing data...")
	while not mode == "finished":
		dir.open("user://level_data/" + Globals.level_name + "/%s/" % mode)
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while not file_name == "":
			var av = ['.', '..']
			if not dir.current_is_dir():
				navbar.set_status_label_text("Packing file: " + file_name.get_file() + "...")
				pck.add_file(Globals.level_name + "/" + mode + "/" + file_name.get_file(), "user://level_data/" + Globals.level_name + "/" + mode + "/" + file_name.get_file())
			file_name = dir.get_next()
		mode_num += 1
		mode = modes[mode_num]
	pck.flush()
	navbar.set_status_label_text("Saving PCK file...")
	OS.alert("Level built to path:\n" + Globals.level_path + "\\" + Globals.level_name + ".pck")
	navbar.set_status_label_text("Level built to path:\n" + Globals.level_path + "\\" + Globals.level_name + ".pck")
func assign_script_to_scene(script_path):
	$".".set_script(script_path)
var _tmp_audio_path = ""
func save_level():
	var cfg = ConfigFile.new()
	config_dirs()
	navbar.set_status_label_text("Saving data...")
	cfg.load("user://level_data/" + Globals.level_name + "/configuration/main.cfg")
	cfg.set_value("nodes", ".", $".".get_children())
	cfg.set_value("values_AudioStreamPlayer", "stream_path", _tmp_audio_path)
	cfg.set_value("info", "author", Globals.level_author)
	cfg.set_value("info", "description", Globals.level_description)
	cfg.set_value("info", "version", Globals.level_version)
	cfg.set_value("info", "name", Globals.level_name)
	cfg.set_value("data", "audio_file_paths", navbar.audio_file_paths)
	cfg.set_value("data", "bg_path", bg_path)
	cfg.save("user://level_data/" + Globals.level_name + "/configuration/main.cfg")
	navbar.set_status_label_text("Project saved!")
func add_audio_from_file(path:String):
	var dir = Directory.new()
	navbar.set_status_label_text("Checking access")
	if dir.copy(path, "user://level_data/" + Globals.level_name + "/custom_audio/" + path.get_file()) == OK:
		_tmp_audio_path = "user://level_data/" + Globals.level_name + "/custom_audio/" + path.get_file()
		navbar.set_status_label_text("Loading...")
		var audio = load("user://level_data/" + Globals.level_name + "/custom_audio/" + path.get_file())
	#	var stream = AudioStream.new()
		$AudioStreamPlayer.stream = audio
	else:
		navbar.set_status_label_text("Access to the file denied")
