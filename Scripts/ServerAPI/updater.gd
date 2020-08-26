extends Control
var intro_played = false
var file = File.new()
func _ready():
	var dir = Directory.new()
	dir.open('user://')
	dir.make_dir('dlcs')
	dir.make_dir('Licenses')
	copy_recursive('res://Licenses/', 'user://Licenses/')
	if not file.file_exists('user://logs/engine_log.txt'):
		dir = Directory.new()
		dir.open('user://')
		dir.make_dir('logs')
	OS.request_permissions()
	$icon.show()
	$Timer.start()
	
#	if intro_played:
#		get_tree().change_scene("res://Scenes/Menu.tscn")
func copy_recursive(from, to):
	var directory = Directory.new()
	
	# If it doesn't exists, create target directory
	if not directory.dir_exists(to):
		directory.make_dir_recursive(to)
	
	# Open directory
	var error = directory.open(from)
	if error == OK:
		# List directory content
		directory.list_dir_begin(true)
		var file_name = directory.get_next()
		while file_name != "":
			if directory.current_is_dir():
				copy_recursive(from + "/" + file_name, to + "/" + file_name)
			else:
				directory.copy(from + "/" + file_name, to + "/" + file_name)
			file_name = directory.get_next()
	else:
		print("Error copying " + from + " to " + to)


func _on_AnimationPlayer_animation_finished(_anim_name):
#	intro_played = true
	get_tree().change_scene('res://Scenes/Menu.tscn')

func _on_Timer_timeout():
#	$AnimationPlayer.play("intro")
	$introzajebistewchuj.play("Intro1")
	
###DLC DOWNLOADING
