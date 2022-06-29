extends Control
var pth
var thread = null
var play_start_transition = false
onready var progress = $progress
signal loaded
var SIMULATED_DELAY_SEC = 0.1
func _ready():
	hide()
var hints = [
	"Destiny is a funny thing, you never know what awaits you.\nBut if you keep an open mind and heart, I promise you will find your own",
	"Perfection and power are overkill,\nI think you are extremely wise in choosing happiness and love",
	"There is nothing wrong with life, peace and well-being.\nIt is better for you to think about what you want out of life and why",
	"You have to let go of your feelings of disgrace if you want to overcome your anger.\nPride is not the opposite of disgrace, but its source.\nTrue humility is the real antidote to dishonor",
	"It is best to admit your mistake when it does and try to regain your honor",
	"It is important to learn from many different places.\nIf you take it from one source only, it will be scrapped.\nUnderstanding other, other elements and nations helps to become whole",
	"Life takes place wherever you are, with or without you",
	"There is nothing wrong with letting loving people help you",
	"Sometimes life is like a dark tunnel, you don't always see the light at the end of this tunnel,\nbut if you keep going, you'll find a better place",
	"It's time for you to look inside yourself and start asking yourself the most important question:\nWho are you and what do you really want?",
	"Use WASD to control Your character and move around!",
	"Tails can't fly!",
	"Thank You for playing Foxy Adventure",
	"OK!",
	"Better don't jump into toxins…",
]
func set_loading_delay(value:float):
	SIMULATED_DELAY_SEC = value
func add_hint(text:String):
	hints.append(text)
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
			ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_LOADING_DATA, false)
			ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_GAME_DATA, false)
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
	$Start_transtition.hide()
	$bg.hide()
	$hint.hide()
	emit_signal("loaded")
	hide()
#	SavingDataIcon.show_up(true, 4)
func load_scene(path):
	show()
	pth = path
#	SavingDataIcon.show_up(true, 4)
	if play_start_transition:
		$Start_transtition.show()
		raise()
		$AnimationPlayer.play("start_transition")
	else:
		$Start_transtition.hide()
		$bg.hide()
		thread = Thread.new()
		thread.start( self, "_thread_load", pth)
		raise() # show on top
		progress.visible = true
	$hint.show()
	randomize_hint()

func randomize_hint():
	randomize()
	var hint = hints[randi() % hints.size()]
	$hint.bbcode_text = "[center]" + hint + "[/center]"
	$hintanimator.play("normal")

func _on_AnimationPlayer_animation_finished(anim_name):
	if str(anim_name) == 'start_transition':
		thread = Thread.new()
		thread.start( self, "_thread_load", pth)
		raise() # show on top
		progress.visible = true

func play_end_transition():
	raise()
	$AnimationPlayer.play("end_transition")


func _on_hintanimator_animation_finished(anim_name):
	randomize_hint()
