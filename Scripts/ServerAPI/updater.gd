extends Control
#var assets_load
#var assets_run_load
#var error_download_load
#var permissions
#var dir = Directory.new()
#var discord_rpc = Discord.new()
var dlc_loader_class = DLCLoader.new()
var file = File.new()
#var save_file = ConfigFile.new()
#onready var downloader = $RequiredAssets
#func _ready():
#	if file.file_exists('user://settings.cfg'):
#		save_file.load('user://settings.cfg')
#		if save_file.has_section_key('Game', 'locale'):
#			TranslationServer.set_locale(str(save_file.get_value('Game', 'locale', 'en')))
#
##	var auth = API.ServerAuth.new()
##	auth.login_player('dd', 'dd', 'dd')
##	print(str(API.Server.new().get_server_ip_adress()))
#	permissions = OS.request_permissions()
#	if file.file_exists('user://assets.pck'):
#		assets_run_load = ProjectSettings.load_resource_pack('user://assets.pck')
#		if assets_run_load == false:
#			error_loading_assets()
#			ProjectSettings.load_resource_pack('user://assets_backup.pck')
#			get_tree().change_scene("res://Scenes/Menu.tscn")
#
#		else:
#			get_tree().change_scene("res://Scenes/Menu.tscn")
##				get_tree().change_scene("res://Scenes/Menu.tscn")
#	else:
#		$AnimationPlayer.play("requesting")
#		downloader.set_download_file('user://assets.pck')
#		downloader.request('https://www.sonadow-dev.ml/game_data/srpg/assets.pck')
#
#func on_assets_downloaded(result, _response_code, _headers, _body):
#	if result == 0:
#		print('Assets Downloaded Successfully!')
#		_ready()
##		assets_load = ProjectSettings.load_resource_pack('user://assets.pck')
##		if assets_load == true:
##			print('Assets Loaded Successfully!')
##			get_tree().change_scene("res://Scenes/Menu.tscn")
##		else:
##			error_loading_assets()
#	else:
#		OS.alert('Error downloading assets!\n\nGame will launch on currently downloaded version if there is one installed!')
#		error_download_load = ProjectSettings.load_resource_pack('user://assets_backup.pck')
#		if error_download_load == false:
#			error_loading_assets()
#		else:
#			var err=get_tree().change_scene("res://Scenes/Menu.tscn")
#			if err == false:
#				error_loading_assets()


#func _process(delta):
#	if not $RequiredAssets.get_body_size() == -1:
#		if not downloader.get_body_size() == 0:
#			$Center/Label.set_text(str(downloader.get_downloaded_bytes()) + '/' + str(downloader.get_body_size()) + ' (' + str((downloader.get_downloaded_bytes()*100/downloader.get_body_size())*1) + '%)')
#		else:
#			$Center/Label.set_text(str(downloader.get_downloaded_bytes()) + '/' + str(downloader.get_body_size()))
#
#func error_loading_assets():
#	dir.open('user://')
#	OS.alert('Error loading assets!\n\nGame will download them again if it is possible!')
#	dir.remove('user://assets.pck')
#	$AnimationPlayer.play("requesting")
#	downloader.set_download_file('user://assets.pck')
#	downloader.request('https://www.sonadow-dev.ml/game_data/srpg/assets.pck')
func _ready():
	
	# set up FMOD
#	Fmod.set_software_format(0, Fmod.FMOD_SPEAKERMODE_STEREO, 0)
#	Fmod.init(1024, Fmod.FMOD_STUDIO_INIT_LIVEUPDATE, Fmod.FMOD_INIT_NORMAL)
#	var instance = int(Fmod.create_sound_instance("res://Audio/BGM/pause_menu.ogg"))
#	Fmod.play_sound(instance)
#	# load banks
#	Fmod.load_bank("res://Master Bank.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
#	Fmod.load_bank("res://Master Bank.strings.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
#	Fmod.load_bank("res://Music.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
#	var music_path = "res://Audio/BGM/credits.ogg"
##	# register listener
#	Fmod.add_listener(0,self)
#	Fmod.load_file_as_music(music_path)
#	var music = Fmod.create_sound_instance(music_path)
#	Fmod.play_sound(music)
#	discord_rpc.start('729429191489093702')
#	discord_rpc.start_time(OS.get_unix_time())
#	if not str(OS.get_name()) == "Android" or str(OS.get_name()) == "OSX":
#		ProjectSettings.load_resource_pack('user://assets.pck')
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
