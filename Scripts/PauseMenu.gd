extends WindowDialog
var visible_connect
var audio = AudioServer
var music_fmod = "res://Audio/BGM/pause_menu.ogg"
var music_fmod_instance
var music_bus_idx = audio.get_bus_index('Music')
var pausemenu_bus_idx = audio.get_bus_index('PauseMenu')
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		visible = !visible
		if visible:
			audio.set_bus_mute(music_bus_idx, true)
			audio.set_bus_mute(pausemenu_bus_idx, false)
			$MusicDelay.start()
		else:
			audio.set_bus_mute(music_bus_idx, false)
			audio.set_bus_mute(pausemenu_bus_idx, true)
			$MusicDelay.stop()
			Fmod.stop_sound(Globals.fmod_sound_music_instance)
#			Fmod.set_sound_paused(music_fmod_instance, true)


func _ready():
	Fmod.add_listener(0, self)
	Fmod.set_pause_mode(Node.PAUSE_MODE_PROCESS)
	Fmod.load_file_as_sound(music_fmod)
	Globals.fmod_sound_music_instance = Fmod.create_sound_instance(music_fmod)
	visible_connect = connect("visibility_changed", self, "_on_visibility_changed")

func _on_visibility_changed():
	get_tree().paused = visible

func _on_Resume_pressed():
	hide()
	$PauseMenu.stop()


func _on_Options_pressed():
	$Control.popup_centered()


func _on_QuitGame_pressed():
	$QuitTOMenuDIalog.popup_centered()

func _on_QuitTOMenuDIalog_confirmed():
	get_tree().quit()
#	get_tree().paused = false
##	BackgroundLoad.play_start_transition = false
#	audio.set_bus_mute(music_bus_idx, false)
##	audio.set_bus_mute(pausemenu_bus_idx, true)
##	$MusicDelay.stop()
##	$PauseMenu.stop()
#	get_tree().change_scene('res://Scenes/Menu.tscn')


func _on_MusicDelay_timeout():
	Fmod.play_sound(Globals.fmod_sound_music_instance)
#	$PauseMenu.play()
