extends Control
var pth
var thread = null
var play_start_transition = false
onready var progress = $progress

var SIMULATED_DELAY_SEC = 1.0

func _thread_load(path):
	var ril = ResourceLoader.load_interactive(path)
	assert(ril)
	var total = ril.get_stage_count()
	# Call deferred to configure max load steps
	progress.call_deferred("set_max", total)
	
	var res = null
	
	while true: #iterate until we have a resource
		# Update progress bar, use call deferred, which routes to main thread
		progress.call_deferred("set_value", ril.get_stage())
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
	progress.hide()
	
	# Instantiate new scene
	var new_scene = resource.instance()
	# Free current scene
	get_tree().current_scene.free()
	get_tree().current_scene = null
	# Add new one to root
	get_tree().root.add_child(new_scene) 
	# Set as current scene
	get_tree().current_scene = new_scene
	
	progress.visible = false
	
func load_scene(path):
	pth = path
	if play_start_transition:
		raise()
		$AnimationPlayer.play("start_transition")
	else:
		$bg.hide()
		thread = Thread.new()
		thread.start( self, "_thread_load", pth)
		raise() # show on top
		progress.visible = true

	


func _on_AnimationPlayer_animation_finished(anim_name):
	if str(anim_name) == 'start_transition':
		thread = Thread.new()
		thread.start( self, "_thread_load", pth)
		raise() # show on top
		progress.visible = true

func play_end_transition():
	raise()
	$AnimationPlayer.play("end_transition")
