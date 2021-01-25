extends Panel
var visible_connect
var audio = AudioServer
var current_submenu_page
var coins
var music_bus_idx = audio.get_bus_index('Music')
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		visible = !visible
	get_tree().paused = visible
func _ready():
	coins = Globals.coins
func _on_Resume_pressed():
	visible = !visible


func _on_Options_pressed():
	show_submenu_page($Control)

func show_submenu_page(page):
	if current_submenu_page != null:
		page.show()
		if not current_submenu_page == page:
			current_submenu_page.hide()
	else:
		page.show()
		current_submenu_page = page
		
func _on_QuitGame_pressed():
	$QuitTOMenuDIalog.popup_centered()

func _on_QuitTOMenuDIalog_confirmed():
	visible = !visible
	get_tree().change_scene('res://Scenes/Menu.tscn')
	Globals.RPCKill()

func _on_FeedBack_pressed():
	$HTTPRequest.send_feedback()
func restart():
	get_tree().reload_current_scene()
	Globals.coins = coins


func _on_Restart_pressed():
	restart()
