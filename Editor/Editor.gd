
extends Node2D
var editor_mode = "MODE_EDIT"
onready var startup_pos_node = $Position2D
var bg_path = 'none'
onready var navbar = $"../CanvasLayer/navbar"
var modes = ["configuration", "finished"]
signal stage_preloaded


var audio_id
var bg_id

func set_startup_position(pos:Vector2):
	startup_pos_node.position = pos

func preload_stage(path):
	load_stage(path)
	emit_signal("stage_preloaded")
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
func load_stage_from_pck(path:String):
	var world_name = path.get_file().get_basename()
	ProjectSettings.load_resource_pack(path)
	var base_path = "res://" + world_name
	var cfg = ConfigFile.new()
	cfg.load(base_path + "/configuration/main_compiled.cfg")
	for i in Array(cfg.get_value("nodes", ".")):
		print("Adding " + str(i) + " to scene...")
		i.name = i.get_class()
		add_child(i)
	if cfg.get_value("data", "bg_path") != 'none':
		add_bg(cfg.get_value("data", "bg_path"))
	if cfg.has_section_key("values_AudioStreamPlayer", "stream_path"):
		if not cfg.get_value("values_AudioStreamPlayer", "stream_path") == "":
			$AudioStreamPlayer.stream = load(cfg.get_value("values_AudioStreamPlayer", "stream_path"))
		$AudioStreamPlayer.play()
	var character = load(str(Globals.character_path)).instance()
	
	add_child(character)
	var game_ui_scene = preload("res://Scenes/game_ui.tscn").instance()
	get_node(str(character.name)).add_child(game_ui_scene)
	character.set_position($Position2D.position)



func load_stage(path):
	if editor_mode == "MODE_EDIT":
		$"../CanvasLayer/TileSelector".set_disabled(false)
	if editor_mode == "MODE_EDIT":
		navbar.set_status_label_text("Loading project from: " + path + "...")
	var cfg = ConfigFile.new()
	cfg.load(path + "/configuration/main.cfg")
	if editor_mode == "MODE_EDIT":
		navbar.set_status_label_text("Clearing tree...")
	for i in $".".get_children():
		if editor_mode == "MODE_EDIT":
			navbar.set_status_label_text("Removing: " + str(i) + "...")
		remove_child(i)
	if editor_mode == "MODE_EDIT":
		navbar.set_status_label_text("Tree cleared")
		navbar.set_status_label_text("Setting up nodes...")
	for i in Array(cfg.get_value("nodes", ".")):
		print("Adding " + str(i) + " to scene...")
		if editor_mode == "MODE_EDIT":
			navbar.set_status_label_text("Setting up: " + str(i) + "...")
		i.name = i.get_class()
		add_child(i)
	if editor_mode == "MODE_EDIT":
		navbar.set_status_label_text("Nodes set up done")
		navbar.set_status_label_text("Gathering required information...")
	_tmp_audio_path = cfg.get_value("values_AudioStreamPlayer", "stream_path")
	Globals.level_author = cfg.get_value("info", "author")
	Globals.level_description = cfg.get_value("info", "description")
	Globals.level_version = cfg.get_value("info", "version")
	Globals.level_name = cfg.get_value("info", "name")
	audio_id = cfg.get_value("data", "audio_id")
	bg_id = cfg.get_value("data", "bg_id")
	if editor_mode == "MODE_EDIT":
		navbar.audio_file_paths = cfg.get_value("data", "audio_file_paths")
	if cfg.get_value("data", "bg_path") != 'none':
		add_bg(cfg.get_value("data", "bg_path"))
	if editor_mode == "MODE_EDIT":
		navbar.set_status_label_text("Project setup done")
	if editor_mode == "MODE_PLAY":
		$ColorRect.hide()
		if cfg.has_section_key("values_AudioStreamPlayer", "stream_path"):
			if not cfg.get_value("values_AudioStreamPlayer", "stream_path") == "":
				$AudioStreamPlayer.stream = load(cfg.get_value("values_AudioStreamPlayer", "stream_path"))
		$AudioStreamPlayer.play()
		var character = load(str(Globals.character_path)).instance()
		add_child(character)
		character.set_position($Position2D.position)
#	$AudioStreamPlayer.autoplay = cfg.get_value("values_AudioStreamPlayer", "autoplay")
func _ready() -> void:
	if Globals.called_from_menu:
		editor_mode = "MODE_PLAY"
	if Globals.called_from_menu_level_name != "":
		load_stage_from_pck(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/New DEV/Foxy Adventure/Levels/Editor/" + Globals.called_from_menu_level_name + ".pck")
#	config_dirs()
	if editor_mode == "MODE_PLAY":
		$ColorRect.hide()
	if editor_mode == "MODE_EDIT":
		$ColorRect.show()
		$"../CanvasLayer/TileSelector".set_disabled(true)
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
func add_bg(bg_idx:int):
	var file_path = EditorGlobals.backrounds[bg_idx]
	var n = load(file_path).instance()
	add_child(n)
	bg_id = bg_idx
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("paint_tile") and editor_mode == "MODE_EDIT":
		if EditorGlobals.can_place_tiles == true:
			$TileMap.paint_tile(get_local_mouse_position(), 8)
func cumpute_file_path(original_path:String):
	if original_path.begins_with("user://"):
		var _tmp_original_path = original_path.split("/")
		_tmp_original_path.remove(0)
		_tmp_original_path.remove(0)
		_tmp_original_path.remove(0)
		var _tmp_cumputed_path = "res:/"
		for i in _tmp_original_path:
			_tmp_cumputed_path += "/" + i
		return _tmp_cumputed_path

func build_level():
	if $ColorRect != null:
		$ColorRect.hide()
	var cfg = ConfigFile.new()
	config_dirs()
	var dir = Directory.new()
	dir.copy("user://level_data/" + Globals.level_name + "/configuration/main.cfg", "user://level_data/" + Globals.level_name + "/configuration/main_compiled.cfg")
	## FOR BUILDING ALL PATHS OF DEPENDENCIES NEEDS TO BE REDEFINED
	navbar.set_status_label_text("Reconfiguring paths for dependencies...")
	cfg.load("user://level_data/" + Globals.level_name + "/configuration/main_compiled.cfg")
	cfg.set_value("nodes", ".", $".".get_children())
#	cumpute_file_path("user://level_data/drthfs/sdfsdf/dgfsdg/dfsd.cfgs") #[user:, , level_data, drthfs, sdfsdf, dgfsdg, dfsd.cfgs]
	cfg.set_value("values_AudioStreamPlayer", "stream_path", cumpute_file_path(_tmp_audio_path))
	cfg.set_value("data", "bg_path", cumpute_file_path(bg_path))
	cfg.set_value("info", "author", Globals.level_author)
	cfg.set_value("info", "description", Globals.level_description)
	cfg.set_value("info", "version", Globals.level_version)
	cfg.set_value("info", "name", Globals.level_name)
	cfg.save("user://level_data/" + Globals.level_name + "/configuration/main_compiled.cfg")
	navbar.set_status_label_text("Done")
	var pck = PCKPacker.new()
	navbar.set_status_label_text("Creating PCK file...")
	pck.pck_start(Globals.level_path + Globals.level_name + ".pck")
	navbar.set_status_label_text("Created")
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
				pck.add_file("res://" + Globals.level_name + "/" + mode + "/" + file_name.get_file(), "user://level_data/" + Globals.level_name + "/" + mode + "/" + file_name.get_file())
			file_name = dir.get_next()
		mode_num += 1
		mode = modes[mode_num]
	pck.flush()
	navbar.set_status_label_text("Saving PCK file...")
	OS.alert("Level built to path:\n" + Globals.level_path + Globals.level_name + ".pck")
	navbar.set_status_label_text("Level built to path: " + Globals.level_path + Globals.level_name + ".pck")
	if $ColorRect != null:
		$ColorRect.show()
func assign_script_to_scene(script_path):
	$".".set_script(script_path)
var _tmp_audio_path = ""
func save_level():
	$"../CanvasLayer/TileSelector".set_disabled(false)
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
	cfg.set_value("info", "name_org", Globals.level_name_org)
	cfg.set_value("data", "audio_id", audio_id)
	cfg.set_value("data", "bg_id", bg_id)
	cfg.save("user://level_data/" + Globals.level_name + "/configuration/main.cfg")
	navbar.set_status_label_text("Project saved!")
## DEPREACTED, TO REPLACE WITH add_audio
func add_audio_from_file(path:String):
	var dir = Directory.new()
	navbar.set_status_label_text("Checking access")
	if dir.copy(path, "user://level_data/" + Globals.level_name + "/custom_audio/" + path.get_file()) == OK:
		_tmp_audio_path = "user://level_data/" + Globals.level_name + "/custom_audio/" + path.get_file()
		navbar.set_status_label_text("Loading...")
		var audio = load("user://level_data/" + Globals.level_name + "/custom_audio/" + path.get_file())
	#	var stream = AudioStream.new()
		$AudioStreamPlayer.stream = audio
		navbar.set_status_label_text("Audio loaded")
	else:
		navbar.set_status_label_text("Access to the file denied")

func add_audio(idx:int):
	navbar.set_status_label_text("Loading...")
#	var audio_path = EditorGlobals.audios[idx]
	audio_id = idx
	navbar.set_status_label_text("Audio loaded")
func _on_ColorRect_mouse_entered():
	pass
#	if Input.is_action_pressed("paint_tile"):
#		$ColorRect.position = get_local_mouse_position()
#	$ColorRect.modulate = Color(255, 255, 255, 255)


func _on_ColorRect_mouse_exited():
	pass
#	$ColorRect.modulate = Color(255, 255, 255, 160)
