
extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

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
	$TileMap.paint_tile(Vector2(100, 100), 4)
func clear_all():
	if $TileMap:
		$TileMap.clear()

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
	var modes = ["custom_audio", "custom_tiles", "finished"]
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
		mode[mode_num]
	pck.flush()
func assign_script_to_scene(script_path):
	$".".set_script(script_path)
func save_level():
	var p_scn = PackedScene.new()
	p_scn.pack($".")
	p_scn.pack($TileMap)
	ResourceSaver.save(Globals.level_path + "/" + Globals.level_name + ".tscn", p_scn)
