extends WindowDialog
var visible_connect
var audio = AudioServer
var music_bus_idx = audio.get_bus_index('Music')
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		visible = !visible
	get_tree().paused = visible

func _on_Resume_pressed():
	visible = !visible


func _on_Options_pressed():
	$Control.popup_centered()


func _on_QuitGame_pressed():
	$QuitTOMenuDIalog.popup_centered()

func _on_QuitTOMenuDIalog_confirmed():
	visible = !visible
	get_tree().change_scene('res://Scenes/Menu.tscn')


func _on_MusicDelay_timeout():
	$PauseMenu.play()


func _on_FeedBack_pressed():
	$HTTPRequest.send_feedback()
