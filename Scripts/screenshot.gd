extends Node
# var image = get_viewport().get_texture().get_data()
var docs_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
var directory = Directory.new()
var year = OS.get_date().year
var month = OS.get_date().month
var day = OS.get_date().day
var hour = OS.get_time().hour
var minute = OS.get_time().minute
var second = OS.get_time().second
func take_screen():
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	image.save_png(docs_dir + "/Sonadow RPG/Screenshots/Screenshot_%s%s%s_%s%s%s.png"%[year, month, day, hour, minute, second])
func _input(event):
	if event.is_action_pressed("screen"):
		take_screen()
func _ready():
	if directory.dir_exists(docs_dir + "/Sonadow RPG/Screenshots/"):
		pass
	else:
		directory.open(docs_dir)
		directory.make_dir("Sonadow RPG")
		directory.open(docs_dir + "/Sonadow RPG")
		directory.make_dir("Screenshots")
