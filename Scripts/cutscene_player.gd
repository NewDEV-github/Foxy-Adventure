extends VideoPlayer
var is_able_to_skip = false
var thread = null
var regex = RegEx.new()
#var regexmatch = RegExMatch.new()
var f = File.new()
#var play_start_transition = false
#onready var progress = $progress
var search_regex = "\\d\\n(\\d{2}:){2}\\d{2},\\d{3}\\s+-->\\s+(\\d{2}:){2}\\d{2},\\d{3}"
var SIMULATED_DELAY_SEC = 1.0
export var scene_to_preload:PackedScene setget set_scene_to_preload, get_scene_to_preload
export var preload_scene:bool
export var can_skip_cutscene:bool
export var subtitles_enanled:bool setget set_subtitles_enabled, get_subtitles_enabled
export var subtitles_file:String setget set_subtitles_file, get_subtitles_file
#autochange scene if preoladed after finished playing cutscene
export var autochange_scene:bool
export var skip_button:NodePath
class_name CutsceneVideoPlayer
export var subtitles_text_rich_text_label:NodePath
var scene_path


func set_subtitles_enabled(s_enabled:bool):
	subtitles_enanled = s_enabled

func get_subtitles_enabled():
	return subtitles_enanled

func change_scene_after_cutscene():
	if not scene_to_preload == null:
		if autochange_scene:
			if preload_scene:
				pass
			else:
				get_tree().change_scene(str(scene_path))
		else:
			pass
	else:
		pass
func _ready():
	set_process(false)
	if scene_to_preload != null:
		scene_path = scene_to_preload.resource_path
	get_node(skip_button).hide()
	connect("finished", self, "change_scene_after_cutscene")
	get_node(skip_button).connect("pressed", self, "skipped")
	get_node(subtitles_text_rich_text_label).bbcode_enabled = true
	regex.compile(search_regex)
	f.open(str(subtitles_file), File.READ)
	set_process(true)
func skipped():
	pass
func get_scene_to_preload():
	return scene_to_preload

func set_scene_to_preload(scene:PackedScene):
	scene_to_preload = scene

func set_subtitles_file(path:String):
	subtitles_file = path

func get_subtitles_file():
	return subtitles_file

func _process(delta):
#	print(stream_position)
#	var config = ConfigFile.new()
	var string = f.get_line()
	if string != null:
#		print("print'y rezultatow z regexa")
		if f.eof_reached():
#			print("koniec pliku, idz w cholere")
			return #koniec pliku, idz w cholere
		var file_pos = f.get_position() #zapamietaj pozycje pliku
		string += "\n" + f.get_line()
		var result = regex.search_all(string)
		if result:
			pass
		else:
			f.seek(file_pos)
			pass
		print(str(result[0]))
#		print(str(result))
func _thread_load(path):
	var ril = ResourceLoader.load_interactive(path)
	assert(ril)
	var total = ril.get_stage_count()
	# Call deferred to configure max load steps
#	progress.call_deferred("set_max", total)
	
	var res = null
	
	while true: #iterate until we have a resource
		# Update progress bar, use call deferred, which routes to main thread
#		progress.call_deferred("set_value", ril.get_stage())
		# Simulate a delay
		OS.delay_msec(SIMULATED_DELAY_SEC * 1000.0)
		# Poll (does a load step)
		var err = ril.poll()
		# if OK, then load another one. If EOF, it' s done. Otherwise there was an error.
		if err == ERR_FILE_EOF:
			# Loading done, fetch resource
			res = ril.get_resource()
			break
		elif err != OK:
			# Not OK, there was an error
			print("There was an error loading")
			break
	
	# Send whathever we did (or not) get
	call_deferred("_thread_done", res)

func _thread_done(resource):
	assert(resource)
	
	# Always wait for threads to finish, this is required on Windows
	thread.wait_to_finish()
	
	#Hide the progress bar
#	progress.hide()
	
	# Instantiate new scene
	var new_scene = resource.instance()
	# Free current scene
	get_tree().current_scene.free()
	get_tree().current_scene = null
	# Add new one to root
	get_tree().root.add_child(new_scene) 
	# Set as current scene
	is_able_to_skip = true
	get_node(skip_button).show()


func start_cutscene():
	play()
	if preload_scene:
		thread = Thread.new()
		thread.start(self, "_thread_load", scene_path)
