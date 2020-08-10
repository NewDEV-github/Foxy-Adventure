extends Control
#var assets_load
#var assets_run_load
#var error_download_load
#var permissions
#var dir = Directory.new()
#var discord_rpc = DISCORD_RPC.new()
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
#
#
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
#	discord_rpc.start('729429191489093702')
#	discord_rpc.start_time(OS.get_unix_time())
#	if not str(OS.get_name()) == "Android" or str(OS.get_name()) == "OSX":
#		ProjectSettings.load_resource_pack('user://assets.pck')
	if file.file_exists('user://dlcs/dlc_foxes.pck'):
		ProjectSettings.load_resource_pack('user://dlcs/dlc_foxes.pck', false)
		var script = load('res://dlcs/dlc_foxes.gd').new()
		script.add_characters()
		script.add_dlc()
		script.add_worlds()
	else:
		var dir = Directory.new()
		dir.open('user://')
		dir.make_dir('dlcs')
		dir.make_dir('Licenses')
		dir.copy('res://Licenses/', 'user://Licenses/')
	if not file.file_exists('user://logs/engine_log.txt'):
		var dir = Directory.new()
		dir.open('user://')
		dir.make_dir('logs')
	OS.request_permissions()
#	get_tree().change_scene("res://Scenes/Menu.tscn")
