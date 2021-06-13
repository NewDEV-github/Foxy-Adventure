extends Control
var intro_played = false
var file = File.new()
var cfg = ConfigFile.new()
func change_text_autosave():
	$CharacterCopyright.bbcode_text = "[center][color=red]" + tr("KEY_TEXT_WARNING") + "[/color][color=white]\n" + tr("KEY_TEXT_AUTOSAVE") + "\n[/color][/center]"
func _ready():
	$CharacterCopyright.bbcode_text = "[center][color=red]" + tr("KEY_TEXT_WARNING") + "[/color][color=white]\n" + tr("KEY_TEXT_INTRO_1") + "\n[/color][/center]"
	cfg.load("user://settings.cfg")
	if cfg.has_section_key('Graphics', 'window_x_resolution') and cfg.has_section_key('Graphics', 'window_y_resolution'):
		OS.set_window_size(Vector2(float(str(cfg.get_value('Graphics', 'window_x_resolution', 1024))), float(str(cfg.get_value('Graphics', 'window_y_resolution', 600)))))
#	if file.file_exists("user://settings.cfg") and not cfg.has_section_key('Game', 'discord_sdk_enabled'):
#		$ConfirmationDialog.popup_centered()
#	elif not file.file_exists("user://settings.cfg"):
#		$ConfirmationDialog.popup_centered()
#		var player = OS.native_video_play("res://assets/Animations/intro.webm",0,"1","1")
#		print(str(player))
	file = File.new()
#	print(str(PI))
#	if Globals.release_mode:
#		load_assets()
#	ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_DOWNLOADING_DATA)
#	BackgroundLoad.get_node("bgload").load_scene("res://s.tscn")
	var dir = Directory.new()
	dir.open('user://')
	dir.make_dir('dlcs')
	if not file.file_exists('user://logs/engine_log.txt'):
		dir = Directory.new()
		dir.open('user://')
		dir.make_dir('logs')
	OS.request_permissions()
	
#	$icon.show()
	$VideoPlayer.stop()
	#OS.native_video_play("res://assets/Animations/intro2.mp4",0, "", "" )
	
#	if intro_played:
#		get_tree().change_scene("res://Scenes/Menu.tscn")
func _process(delta: float) -> void:
	if DiscordSDK.discord_user_img:
		$Icon.texture = DiscordSDK.discord_user_img
	if Input.is_action_just_pressed("ui_accept"):
		_on_VideoPlayer_finished()
func _on_AnimationPlayer_animation_finished(_anim_name):
	if not str(OS.get_name()) == "Android":
		var stream = VideoStreamGDNative.new()
		var file = "res://assets/Animations/intro_vp8.webm"#supports for now
		print(file)
		stream.set_file(file)
		var vp = $VideoPlayer
		vp.stream = stream
		var sp = vp.stream_position
		# hack: to get the stream length, set the position to a negative number
		# the plugin will set the position to the end of the stream instead.
		vp.stream_position = -1
		var duration = vp.stream_position
	#	$ProgressBar.max_value = duration
		vp.stream_position = sp
		vp.play()
		yield($VideoPlayer,"finished")
	else:
		_on_VideoPlayer_finished()
###DLC DOWNLOADING

func _on_VideoPlayer_finished():
	if not OS.get_name() == "Android":
		if not get_tree().change_scene('res://Scenes/Menu.tscn') == 0:
			ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_GAME_DATA)
			print(get_tree().change_scene('res://Scenes/Menu.tscn'))
	elif OS.get_name() == "Android":
		if not get_tree().change_scene("res://Scenes/Menu_android.tscn") == 0:
			ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_GAME_DATA)


func _on_ConfirmationDialog_confirmed():
	get_tree().paused = false
	Globals.enable_discord_sdk(true)


func _on_ConfirmationDialog_popup_hide():
	get_tree().paused = false


func _on_ConfirmationDialog_about_to_show():
	get_tree().paused = true
