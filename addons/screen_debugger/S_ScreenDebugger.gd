extends Node
var log_text = ""
#var _scn:PackedScene = preload("res://addons/screen_debugger/screen.scn")
onready var label = $Control/Panel/Label
func _ready():
#	var c_script = preload("res://addons/godot-console-dev/src/Misc/BaseCommands.gd").new()
#	c_script.connect("take_log", self, "take_log")
	set_process(false)
	Globals.connect("loaded", self, "g_tree_entered")
func g_tree_entered():
	set_process(true)
func _process(delta):
	var perf_data = Fmod.get_performance_data()
	log_text = str(
		'\n\nFMOD Sound System',
		'\nCPU usage: ' + str(perf_data.CPU),
		'\nFile: ' + str(perf_data.file),
		'\nMemory usage: ' + str(perf_data.memory),
		'\n\nGame info',
		'\nCreator: New DEV',
		'\nName: Foxy Adventure',
		'\nEngine version: ' +str(Engine.get_version_info()),
		'\n\nEngine variables',
		'\nuser data dir: ' + str(OS.get_user_data_dir()),
		'\ntarget FPS: ' + str(Engine.target_fps),
		'\nFPS: ' + str(Engine.get_frames_per_second()),
		'\n\nGlobals.gd variables',
		'\nselected_character: '+ str(Globals.selected_character),
		'\ncharacter_path: '+ str(Globals.character_path),
		'\ncharacter_position: '+ str(Globals.character_position),
		'\nis_coming_from_house: '+ str(Globals.coming_from_house),
		'\nlast_position_on_world: '+ str(Globals.last_world_position),
		'\nworld: '+ str(Globals.world),
		'\ndebugMode: '+ str(Globals.debugMode),
		'\nwindow_x_resolution: '+ str(Globals.window_x_resolution),
		'\nwindow_y_resolution: '+ str(Globals.window_y_resolution)
	)
	label.text = log_text
func take_log():
	pass
