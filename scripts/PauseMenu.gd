extends Panel
var visible_connect
var audio = AudioServer
var current_submenu_page
func _ready():
	if Globals.arguments.has("locale"):
		print("Setting locale to: " + Globals.arguments["locale"])
		TranslationServer.set_locale(Globals.arguments["locale"])
var music_bus_idx = audio.get_bus_index('Music')
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		visible = !visible
		get_tree().paused = visible
func _on_Resume_pressed():
	hide()
	get_tree().paused = false


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
	DiscordSDK.kill_rpc()

func _on_FeedBack_pressed():
	$HTTPRequest.send_feedback()
func restart():
	get_tree().reload_current_scene()

func _on_Restart_pressed():
	restart()
