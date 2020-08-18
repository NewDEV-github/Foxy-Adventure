extends Control
var file = File.new()
var dlc_loader_class = google.new()

func _ready():
	download_dlc_list()
	dlc_loader_class.load_all_dlcs()
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
	get_tree().change_scene("res://Scenes/Menu.tscn")


func _on_Timer_timeout():
	$AnimationPlayer.play("intro")
func download_dlc_list():
	print('downloading dlc list')
	$RequiredAssets.set_download_file("user://dlcs/dlc_list.gd")
	$RequiredAssets.request("https://dl.new-dev.tk/data/games/dlcs/foxy-adventure/dlc_list.gd")
func load_dlc_list(result, response_code, headers, body):
	var script = load("user://dlcs/dlc_list.gd").new()
	Globals.dlc_name_list = script.dlc_list
	print(str(Globals.dlc_name_list))
	for cfg in Globals.dlc_name_list:
		print(str(cfg))
		var str_cfg = str(cfg)
		var cfg_number = 1
		$CFGDownloader.set_download_file("user://dlcs/" + str(cfg_number) + '.cfg')
		$CFGDownloader.request(cfg)
		cfg_number += 1

