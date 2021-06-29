
extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var modes = ["custom_audio", "custom_tiles", "finished"]
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
	var p_scn = PackedScene.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dir = Directory.new()
	var mode_num = 0
	var mode = modes[mode_num]
	if not dir.dir_exists("user://level_data/"):
		dir.make_dir("user://level_data/")
	if not dir.dir_exists("user://level_data/" + Globals.level_name):
		dir.open("user://level_data/")
		dir.make_dir(Globals.level_name)
	while not mode == "finished":
		dir.open("user://level_data/" + Globals.level_name)
		if not dir.dir_exists(mode):
			dir.make_dir(mode)
		mode_num += 1
		mode = modes[mode_num]
func clear_all():
	if $TileMap:
		$TileMap.clear()
func add_bg(file_path:String):
	var n = load(file_path).instance()
	add_child(n)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("paint_tile"):
		$TileMap.paint_tile(get_global_mouse_position(), 8)
func build_level():
	var pck = PCKPacker.new()
	pck.pck_start(Globals.level_path + "/" + Globals.level_name + ".pck")
	var dir = Directory.new()
	#custom_audio
	var mode_num = 0
	var mode = modes[mode_num]
	while not mode == "finished":
		dir.open("user://level_data/" + Globals.level_name + "/%s/" % mode)
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while not file_name == "":
			var av = ['.', '..']
			if not dir.current_is_dir():
				pck.add_file(Globals.level_name + "/%s/" + file_name.get_file() % mode, "user://level_data/" + Globals.level_name + "/%s/" + file_name.get_file() % mode)
			file_name = dir.get_next()
		mode_num += 1
		mode = modes[mode_num]
	pck.flush()
	OS.alert("Level built to path:\n" + Globals.level_path + "/" + Globals.level_name + ".pck")
func assign_script_to_scene(script_path):
	$".".set_script(script_path)
func save_level():
	var p_scn = PackedScene.new()
	p_scn.pack(get_node("."))
	p_scn.pack(get_node("TileMap"))
	ResourceSaver.save(Globals.level_path + "/" + Globals.level_name + ".tscn", p_scn)
func add_audio_from_file(path:String):
	var dir = Directory.new()
	if dir.copy(path, "user://level_data/" + Globals.level_name + "/custom_audio/" + path.get_file()) == OK:
		var audio = load("user://level_data/" + Globals.level_name + "/custom_audio/" + path.get_file())
	#	var stream = AudioStream.new()
		$AudioStreamPlayer.stream = audio
