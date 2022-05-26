extends Control
var intro_played = false
var file = File.new()
var cfg = ConfigFile.new()
func change_text_autosave():
	$CharacterCopyright.bbcode_text = "[center][color=red]" + 'Warning' + "[/color][color=white]\n" + "This game uses an autosave.\nPlease, don't turn off the game while that icon is displayed" + "\n[/color][/center]"
func _ready():
	$lightmask.hide()
	while Globals.loaded == true:
		cfg.load("user://settings.cfg")
#		if cfg.has_section_key('Graphics', 'window_x_resolution') and cfg.has_section_key('Graphics', 'window_y_resolution'):
#			OS.set_window_size(Vector2(float(str(cfg.get_value('Graphics', 'window_x_resolution', 1024))), float(str(cfg.get_value('Graphics', 'window_y_resolution', 600)))))
		if file.file_exists("user://settings.cfg") and not cfg.has_section_key('Game', 'use_discord_avatar'):
			$ConfirmationDialog.popup_centered()
		elif not file.file_exists("user://settings.cfg"):
			$ConfirmationDialog.popup_centered()
		else:
			print("Discord avatar is set to: " + cfg.get_value('Game', 'use_discord_avatar', false))
			DiscordSDK.av_en = cfg.get_value('Game', 'use_discord_avatar', false)
		$CharacterCopyright.bbcode_text = "[center][color=red]" + 'Warning' + "[/color][color=white]\n" + 'Sonic and other characters belongs to SEGA and/or their owners' + "\n[/color][/center]"
		$AnimationPlayer.play("intro")
		file = File.new()
		var dir = Directory.new()
		dir.open('user://')
		dir.make_dir('dlcs')
		if not file.file_exists('user://logs/engine_log.txt'):
			dir = Directory.new()
			dir.open('user://')
			dir.make_dir('logs')
		OS.request_permissions()
		$VideoPlayer.stop()
		break
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_on_VideoPlayer_finished()
	yield(DiscordSDK, "user_avatar_loaded")
	if DiscordSDK.discord_user_img != null:
		$Icon.texture = DiscordSDK.discord_user_img
		$lightmask.show()
	
func _on_AnimationPlayer_animation_finished(_anim_name):
	if not str(OS.get_name()) == "Android":
		var stream = VideoStreamGDNative.new()
		var file = "res://assets/Animations/intro_vp8.webm"#supports for now
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
		if not get_tree().change_scene('res://Scenes/Menu.tscn') == OK:
			ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_GAME_DATA)
			print(get_tree().change_scene('res://Scenes/Menu.tscn'))
	elif OS.get_name() == "Android":
		if not get_tree().change_scene("res://Scenes/Menu_android.tscn") == OK:
			ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_GAME_DATA)


func _on_ConfirmationDialog_confirmed():
	get_tree().paused = false
	DiscordSDK.av_en = "True"


func _on_ConfirmationDialog_popup_hide():
	get_tree().paused = false
	DiscordSDK.av_en = "False"


func _on_ConfirmationDialog_about_to_show():
	get_tree().paused = true
