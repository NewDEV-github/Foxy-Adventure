extends WindowDialog
var dir = Directory.new()
var save_file = ConfigFile.new()
var file = File.new()
var tr_en_fallback = [
	"EN_US"
]
#var dlc_web_avaliable = Globals.get_dlcs_avaliable()
func _ready():
	set_process(false)
#	$tabs.set_tab_disabled(1, true)
#	$tabs/Inne/VBoxContainer/InstallDLC.set_disabled(!dlc_web_avaliable)
	if tr_en_fallback.has(str(TranslationServer.get_locale().to_upper())):
		$"tabs/Ogólne/Options/Graphics/lang/lang".text = tr("KEY_OPTIONS_LANG_" + str(TranslationServer.get_locale().to_upper()))
	else:
		$"tabs/Ogólne/Options/Graphics/lang/lang".text = tr("KEY_OPTIONS_LANG_EN")
	$tabs.set_tab_title(0, "KEY_OPTIONS_GENERAL")
	$tabs.set_tab_title(1, "KEY_OPTIONS_STEERING")
#	$tabs.set_tab_title(2, "KEY_OPTIONS_GAMEPLAY")
#	$tabs.set_tab_title(3, "KEY_OPTIONS_OTHER")
	$"tabs/Ogólne/Options/Graphics/fps/target".value = Engine.target_fps
	
	load_settings()
	if str(OS.get_name()) == 'Android':
#		$tabs/Sterowanie.hide()
		$tabs.set_tab_disabled(1, true)
		$"tabs/Ogólne/Options/Audio/SPEAKERMODE".set_disabled(true)
		$"tabs/Ogólne/Options/Graphics/custom_resolution".hide()
	else:
		$"tabs/Ogólne/Options/Audio/SPEAKERMODE".set_disabled(false)
		$tabs.set_tab_disabled(1, false)
#		$tabs/Sterowanie.show()
		$"tabs/Ogólne/Options/Graphics/custom_resolution".show()
func _process(_delta):
	save_file.load('user://settings.cfg')
	save_file.set_value('Game', 'engine_version', str(Engine.get_version_info()))
	save_file.set_value('Game', 'target_fps', str(Engine.target_fps))
	save_file.set_value('Game', 'locale', str(TranslationServer.get_locale()))
	save_file.set_value('Game', 'game_clock', str(Globals.gc_mode))
	save_file.set_value('Game', 'minimap_enabled', str(!bool(str(Globals.get_minimap_enabled()))))
	save_file.set_value('Audio', 'master_bus_volume', str($"tabs/Ogólne/Options/Audio/Master/Master_slider".value))
	save_file.set_value('Audio', 'master_bus_enabled', str($"tabs/Ogólne/Options/Audio/Master/Master_on".pressed))
	save_file.set_value('Audio', 'music_bus_volume', str($"tabs/Ogólne/Options/Audio/Music/Music_slider".value))
	save_file.set_value('Audio', 'music_bus_enabled', str($"tabs/Ogólne/Options/Audio/Music/Music_on".pressed))
	save_file.set_value('Audio', 'sfx_bus_volume', str($"tabs/Ogólne/Options/Audio/SFX/SFX_slider".value))
	save_file.set_value('Audio', 'sfx_bus_enabled', str($"tabs/Ogólne/Options/Audio/SFX/SFX_on".pressed))
#	save_file.set_value('Graphics', 'fullscreen', str($"tabs/Ogólne/Options/Graphics/Fullscreen".pressed))
	save_file.set_value('Graphics', 'vsync_enabled', str($"tabs/Ogólne/Options/Graphics/VSync".pressed))
	save_file.set_value('Graphics', 'vsync_via_compositor', str($"tabs/Ogólne/Options/Graphics/VSync".pressed))
	save_file.set_value('Graphics', 'window_x_resolution', str($"tabs/Ogólne/Options/Graphics/custom_resolution/x".value))
	save_file.set_value('Graphics', 'window_y_resolution', str($"tabs/Ogólne/Options/Graphics/custom_resolution/y".value))
	save_file.save('user://settings.cfg')
	hide()
	set_process(false)
func load_settings():
	if file.file_exists('user://settings.cfg'):
		save_file.load('user://settings.cfg')
		if save_file.has_section_key('Audio', 'master_bus_volume'):
			$"tabs/Ogólne/Options/Audio/Master/Master_slider".set_value(float(save_file.get_value('Audio', 'master_bus_volume', 0)))
		if save_file.has_section_key('Audio', 'master_bus_enabled'):
			$"tabs/Ogólne/Options/Audio/Master/Master_on".set_pressed(bool(str(save_file.get_value('Audio', 'master_bus_enabled', false))))
		if save_file.has_section_key('Audio', 'music_bus_volume'):
			$"tabs/Ogólne/Options/Audio/Music/Music_slider".set_value(float(save_file.get_value('Audio', 'music_bus_volume', 0)))
		if save_file.has_section_key('Audio', 'music_bus_enabled'):
			$"tabs/Ogólne/Options/Audio/Music/Music_on".set_pressed(bool(str(save_file.get_value('Audio', 'music_bus_enabled', false))))
		if save_file.has_section_key('Audio', 'sfx_bus_volume'):
			$"tabs/Ogólne/Options/Audio/SFX/SFX_slider".set_value(float(save_file.get_value('Audio', 'sfx_bus_volume', 0)))
		if save_file.has_section_key('Audio', 'sfx_bus_enabled'):
			$"tabs/Ogólne/Options/Audio/SFX/SFX_on".set_pressed(bool(str(save_file.get_value('Audio', 'sfx_bus_enabled', false))))
#		if save_file.has_section_key('Graphics', 'fullscreen'):
#			$"tabs/Ogólne/Options/Graphics/Fullscreen".pressed = bool(str(save_file.get_value('Graphics', 'fullscreen', false)))
		if save_file.has_section_key('Graphics', 'vsync_enabled'):
			$"tabs/Ogólne/Options/Graphics/VSync".pressed = bool(str(save_file.get_value('Graphics', 'vsync_enabled', true)))
		if save_file.has_section_key('Graphics', 'window_x_resolution'):
			$"tabs/Ogólne/Options/Graphics/custom_resolution/x".value = float(str(save_file.get_value('Graphics', 'window_x_resolution', 1024)))
		if save_file.has_section_key('Graphics', 'window_y_resolution'):
			$"tabs/Ogólne/Options/Graphics/custom_resolution/y".value = float(str(save_file.get_value('Graphics', 'window_y_resolution', 600)))
		if save_file.has_section_key('Game', 'target_fps'):
			$"tabs/Ogólne/Options/Graphics/fps/target".value = float(str(save_file.get_value('Game', 'target_fps', 60)))
		if save_file.has_section_key('Game', 'locale'):
			TranslationServer.set_locale(str(save_file.get_value('Game', 'locale', 'en')))
#		if save_file.has_section_key('Game', 'minimap_enabled'):
#			$tabs/Rozgrywka/box/minimapenabled/minimap.set_pressed(bool(str(save_file.get_value('Game', 'minimap_enabled', true))))
		if save_file.has_section_key('Game', 'game_clock'):
			Globals.set_day_night_mode(str(save_file.get_value('Game', 'target_fps', 60)))
#		if save_file.has_section_key('Game', 'nsfw_enabled'):
		
#			Globals.set_nsfw(bool(str(save_file.get_value('Game', 'nsfw_enabled',false))))
#			$tabs/Rozgrywka/box/nsfwmode/nsfw.set_pressed(!bool(str(save_file.get_value('Game', 'nsfw_enabled',false))))
		if not str(OS.get_name()) == 'Android':
			Globals.apply_custom_resolution()
		$"tabs/Ogólne/Options/Graphics/custom_resolution/SpinBox".set_text(str($"tabs/Ogólne/Options/Graphics/custom_resolution/x".value) + 'x' + str($"tabs/Ogólne/Options/Graphics/custom_resolution/y".value))
		if save_file.has_section_key('Game', 'debug_mode'):
			Globals.debugMode = bool(str(save_file.get_value('Graphics', 'debug_mode', false)))
		else:
			pass
	else:
		pass
func _on_Master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)


func _on_Master_on_toggled(button_pressed):
	AudioServer.set_bus_mute(0, !button_pressed)
	$"tabs/Ogólne/Options/Audio/Master/Master_slider".editable = button_pressed
	$"tabs/Ogólne/Options/Audio/Music/Music_on".set_pressed(button_pressed)
	$"tabs/Ogólne/Options/Audio/Music/Music_on".set_disabled(!button_pressed)
	$"tabs/Ogólne/Options/Audio/SFX/SFX_on".set_pressed(button_pressed)
	$"tabs/Ogólne/Options/Audio/SFX/SFX_on".set_disabled(!button_pressed)

func _on_Music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)
	AudioServer.set_bus_volume_db(3, value)

func _on_Music_on_toggled(button_pressed):
	AudioServer.set_bus_mute(1, !button_pressed)
	$"tabs/Ogólne/Options/Audio/Music/Music_slider".editable = button_pressed


func _on_SFX_slider_value_changed(value):
#	if value <= 0:
#		Fmod.set_sound_volume(Globals.fmod_sound_sfx_instance, value)
#	else:
#		Fmod.set_sound_volume(Globals.fmod_sound_sfx_instance, 0)
	AudioServer.set_bus_volume_db(2, value)
	

func _on_SFX_on_toggled(button_pressed):
	
	AudioServer.set_bus_mute(2, !button_pressed)
	$"tabs/Ogólne/Options/Audio/SFX/SFX_slider".editable = button_pressed


func _on_Fullscreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed


func _on_SAVE_pressed():
	Globals.apply_custom_resolution()
	set_process(true)


func _on_VSync_toggled(button_pressed):
	OS.vsync_enabled = button_pressed
	OS.vsync_via_compositor = button_pressed


func _on_ClearDownloadedAssets_pressed():
#	dir.open('user://')
	print('Backing up assets...')
	dir.open('user://')
	dir.rename('assets.pck', 'assets_backup.pck')
	var app_path = OS.get_executable_path()
	print('Going to download new version')
	if str(OS.get_name()) == 'Android':
		get_tree().change_scene("res://Scenes/ServerAPI/updater.tscn")
	else:
		OS.execute(str(app_path), [])
		get_tree().quit()


func _on_x_value_changed(value):
	Globals.window_x_resolution = value
	$"tabs/Ogólne/Options/Graphics/custom_resolution/SpinBox".set_text(str(Globals.window_x_resolution) + 'x' + str(Globals.window_y_resolution))


func _on_y_value_changed(value):
	Globals.window_y_resolution = value
	$"tabs/Ogólne/Options/Graphics/custom_resolution/SpinBox".set_text(str(Globals.window_x_resolution) + 'x' + str(Globals.window_y_resolution))

func _on_SpinBox_item_selected(id):
	if id == 0:
		$"tabs/Ogólne/Options/Graphics/custom_resolution/x".value = 640
		$"tabs/Ogólne/Options/Graphics/custom_resolution/y".value = 480
	elif id == 1:
		$"tabs/Ogólne/Options/Graphics/custom_resolution/x".value = 800
		$"tabs/Ogólne/Options/Graphics/custom_resolution/y".value = 480
	elif id == 2:
		$"tabs/Ogólne/Options/Graphics/custom_resolution/x".value = 800
		$"tabs/Ogólne/Options/Graphics/custom_resolution/y".value = 600
	elif id == 3:
		$"tabs/Ogólne/Options/Graphics/custom_resolution/x".value = 1024
		$"tabs/Ogólne/Options/Graphics/custom_resolution/y".value = 600
	elif id == 4:
		$"tabs/Ogólne/Options/Graphics/custom_resolution/x".value = 1280
		$"tabs/Ogólne/Options/Graphics/custom_resolution/y".value = 720
	elif id == 5:
		$"tabs/Ogólne/Options/Graphics/custom_resolution/x".value = 1280
		$"tabs/Ogólne/Options/Graphics/custom_resolution/y".value = 800
	elif id == 6:
		$"tabs/Ogólne/Options/Graphics/custom_resolution/x".value = 1366
		$"tabs/Ogólne/Options/Graphics/custom_resolution/y".value = 768
	elif id == 7:
		$"tabs/Ogólne/Options/Graphics/custom_resolution/x".value = 1440
		$"tabs/Ogólne/Options/Graphics/custom_resolution/y".value = 900
	elif id == 8:
		$"tabs/Ogólne/Options/Graphics/custom_resolution/x".value = 1920
		$"tabs/Ogólne/Options/Graphics/custom_resolution/y".value = 1080
	elif id == 9:
		$"tabs/Ogólne/Options/Graphics/custom_resolution/x".value = 2048
		$"tabs/Ogólne/Options/Graphics/custom_resolution/y".value = 1152
	elif id == 10:
		$"tabs/Ogólne/Options/Graphics/custom_resolution/x".value = 2048
		$"tabs/Ogólne/Options/Graphics/custom_resolution/y".value = 1024
	elif id == 11:
		$"tabs/Ogólne/Options/Graphics/custom_resolution/x".value = 2560
		$"tabs/Ogólne/Options/Graphics/custom_resolution/y".value = 1600
	elif id == 12:
		$"tabs/Ogólne/Options/Graphics/custom_resolution/x".value = 2560
		$"tabs/Ogólne/Options/Graphics/custom_resolution/y".value = 2048
	elif id == 13:
		$"tabs/Ogólne/Options/Graphics/custom_resolution/x".value = 3072
		$"tabs/Ogólne/Options/Graphics/custom_resolution/y".value = 1728
	elif id == 14:
		$"tabs/Ogólne/Options/Graphics/custom_resolution/x".value = 4096
		$"tabs/Ogólne/Options/Graphics/custom_resolution/y".value = 2304
	elif id == 15:
		$"tabs/Ogólne/Options/Graphics/custom_resolution/x".value = 8192
		$"tabs/Ogólne/Options/Graphics/custom_resolution/y".value = 4608
	


func _on_maxfps_value_changed(value):
	Engine.target_fps = value


func _on_gcbutton_item_selected(id):
	if id == 0:
		Globals.set_day_night_mode('realtime')
	if id == 1:
		Globals.set_day_night_mode('gametime')


func _on_lang_item_selected(id):
#	var theme = preload("res://themes/rpgm_like/rpgm_like.tres")
	if id == 0:
		TranslationServer.set_locale("en")
	if id == 1:
		TranslationServer.set_locale("es")
	if id == 2:
		TranslationServer.set_locale("de")
	if id == 3:
		TranslationServer.set_locale("pl")
	if id == 4:
		TranslationServer.set_locale("es_MX")
	if id == 5:
		TranslationServer.set_locale("ja")
	if id == 6:
		TranslationServer.set_locale("ru")
	if id == 7:
#		theme.default_font = preload("res://Fonts/msyhl.tres")
		TranslationServer.set_locale("zh")
	

func default_settings():
	$"tabs/Ogólne/Options/Graphics/custom_resolution/x".value = 1024
	$"tabs/Ogólne/Options/Graphics/custom_resolution/y".value = 600
	$"tabs/Ogólne/Options/Audio/Master/Master_slider".value = 0
	$"tabs/Ogólne/Options/Audio/Music/Music_slider".value = 0
	$"tabs/Ogólne/Options/Audio/SFX/SFX_slider".value = 0
	$"tabs/Ogólne/Options/Graphics/VSync".pressed = true
	$tabs/Rozgrywka/box/game_clock/gcbutton.select(0)
	$"tabs/Ogólne/Options/Graphics/lang/lang".select(0)
	$tabs/Sterowanie/controls_ui._ready()
func _on_RESETSETTINGS_pressed():
	var dir = Directory.new()
	dir.open('user://')
	dir.remove('user://settings.cfg')
	default_settings()
	_ready()



func _on_Licenses_pressed():
	if str(OS.get_name()) == "Android" or str(OS.get_name()) == "OSX":
		OS.shell_open('file://'+ str(OS.get_user_data_dir()) + '/Licenses/')
	else:
		OS.shell_open('file://' + str(OS.get_executable_path()).get_base_dir() + '/Licenses/')


func _on_minimap_toggled(button_pressed):
	Globals.set_minimap_enabled(button_pressed)
