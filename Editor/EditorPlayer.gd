extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	load_stage_from_pck(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/New DEV/Foxy Adventure/Levels/Editor/wer.pck")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func load_stage_from_pck(path:String):
	var world_name = path.get_file().get_basename()
	ProjectSettings.load_resource_pack(path)
	var base_path = "res://" + world_name
	var cfg = ConfigFile.new()
	cfg.load(base_path + "/configuration/main_compiled.cfg")
	## We add $Position2D and AudioStreamPlayer from saved data
	for i in Array(cfg.get_value("nodes", ".")):
		print("Adding " + str(i) + " to scene...")
		i.name = i.get_class()
		add_child(i)
	if str(cfg.get_value("data", "bg_id", 'none')) != 'none':
		add_bg(int(cfg.get_value("data", "bg_id")))
	$AudioStreamPlayer.stream = load(EditorGlobals.audios[int(cfg.get_value("data", "audio_id"))])
	$AudioStreamPlayer.play()
	var character = load(str(Globals.character_path)).instance()
	
	add_child(character)
	var game_ui_scene = preload("res://Scenes/game_ui.tscn").instance()
	get_node(str(character.name)).add_child(game_ui_scene)
	character.set_position($Position2D.position)
func add_bg(bg_idx:int):
	var file_path = EditorGlobals.backrounds[bg_idx]
	var n = load(file_path).instance()
	add_child(n)
