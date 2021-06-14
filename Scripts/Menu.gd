extends Control
var world_scene
var website
var current_submenu_page
#onready var editor_lib = load("res://bin/gdexample.gdns").new()
#var discord_rpc = DISCORD_RPC.new()
var day = OS.get_date().day
var month = OS.get_date().month
onready var world_list = Globals.worlds
# Called when the node enters the scene tree for the first time.
func _on_FirebaseAuth_login_succeeded(auth):
	Firebase.Auth.save_auth(auth)
	Globals.user_data = auth
#	$Account.load_account_info()
	$VBoxContainer3/Info.disabled = false
	$VBoxContainer3/Logout.disabled = false
	$VBoxContainer3/Login.disabled = true
#	var db_ref = Firebase.Database.get_database_reference("test")
#	print("Db ref: " + db_ref.get_data())
#	db_ref.push({"f": "df"})
#	Firebase.Auth.connect("userdata_received", self, "on_userdata_recived")

#func on_userdata_recived(userdata):
#	print(Globals.user_data)
func _ready() -> void:
	$VBoxContainer3/Info.disabled = true
	$VBoxContainer3/Logout.disabled = true
	$VBoxContainer3/Login.disabled = false
	Firebase.Auth.connect("login_succeeded", self, "_on_FirebaseAuth_login_succeeded")
	Firebase.Auth.connect("signup_succeeded", self, "_on_FirebaseAuth_login_succeeded")
	if Firebase.Auth.check_auth_file():
		Firebase.Auth.load_auth()
		Globals.user_data = Firebase.Auth.auth
		$VBoxContainer3/Info.disabled = false
		$VBoxContainer3/Logout.disabled = false
		$VBoxContainer3/Login.disabled = true
#		var db_ref = Firebase.Database.get_database_reference("test")
	#	print("Db ref: " + db_ref.get_data())
#		db_ref.push({"f": ""})
#		$Account.load_account_info()
#		print(Firebase.Auth.auth)
#		print(Globals.user_data['displayname'])
#		print(Globals.user_data['profilepicture'])
#		$TextureRect.textureUrl = Globals.user_data['profilepicture']
#	else:
#		Firebase.Auth.login_with_email_and_password("karoltomaszewskimusic@gmail.com", "Flet2005")
#	Globals.load_achivements()
#	yield(Globals,"achivements_loaded")
	$AchivementPanel/HBoxContainer/Done.clear()
	for i in Globals.done_achievements:
		$AchivementPanel/HBoxContainer/Done.add_item(i)
	$AchivementPanel/HBoxContainer/NotDone.clear()
	for i in Globals.not_done_achievements:
		$AchivementPanel/HBoxContainer/NotDone.add_item(i)
	DiscordSDK.run_rpc(false, false,"", true)
#	print(Fmod.get_music_instances())
#	Fmod.load_file_as_music("res://assets/Audio/BGM/music_gekagd.ogg")
#	Globals.fmod_sound = Fmod.create_sound_instance("res://assets/Audio/BGM/music_gekagd.ogg")
#	Fmod.play_sound(Globals.fmod_sound)
	$version_label.bbcode_text = Globals.construct_game_version()
	Globals.selected_character = null
	Globals.character_path = null
	for world_name in world_list:
		if world_name == [] or world_name == null:
#			ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_LOADING_DATA)
			ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_GAME_DATA)
		$SelectWorld/WorldList.add_item(tr(world_name))
	custom_level_research()
	for world_name in Globals.cworlds:
#		if world_name == [] or world_name == null:
##			ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_LOADING_DATA)
#			ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_GAME_DATA)
		$SelectWorld/WorldList.add_item(world_name)
	Directory.new().make_dir('user://logs/')
	if day == 21 and month == 6:
		$Label.set_text(tr("Happy Birthday to") + ' "Foxy Adventure"')
	elif day == 17 and month == 2:
		$Label.set_text(tr("Happy Birthday to") + ' "NewTheFox" ')
	elif day == 25 and month == 3:
		$Label.set_text(tr("Happy Birthday to") + ' "NewTheFox" ')
	elif day == 14 and month == 9:
		$Label.set_text(tr("Happy Birthday to") + ' Gekon aka "GeKaGD"')
	elif day == 16 and month == 10:
		$Label.set_text(tr("Happy Birthday to") + ' Miles "Tails" Prower')
	elif day == 7 and month == 4:
		$Label.set_text(tr("Happy Birthday to") + ' JezSonic/Futrzak or the main developer')
	get_tree().paused = false
#	$AnimationPlayer.play('end_transition')
	print('Game launched successfully!\n')
	if Globals.arguments.has("locale"):
		print("Setting locale to: " + Globals.arguments["locale"])
		TranslationServer.set_locale(Globals.arguments["locale"])
func show_submenu_page(page):
	if current_submenu_page != null:
		page.show()
		if not current_submenu_page == page:
			current_submenu_page.hide()
	else:
		page.show()
		current_submenu_page = page
func _on_Options_pressed():
	show_submenu_page($Control)


func _on_Quit_pressed():
	get_tree().quit()


func _on_Website_pressed():
	website = OS.shell_open("https://newdev.web.app/games/foxy-adventure")
#	pass     


func _on_Options2_pressed():
	get_tree().change_scene('res://Scenes/Credits.tscn')


func _on_WorldList_item_selected(index):
	pass

func custom_level_research():
	for path in Globals.levels_scan_path:
		var dir = Directory.new()
		if not dir.dir_exists(path):
			dir.open(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS))
			dir.make_dir_recursive(path)
		elif dir.dir_exists(path):
			dir_contents(path)

func dir_contents(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				if file_name.get_extension() == "tscn":
					Globals.add_custom_world(file_name.get_basename())
					dir.copy(path + file_name, Globals.temp_custom_stages_dir + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")





func _on_Feedback_pressed():
	$Feedback.send_feedback()


func _on_NewGame_pressed() -> void:
	$NewSave.popup_centered()


func _on_LoadGame_pressed() -> void:
	show_submenu_page($SaveLoader)


func _on_CreateNewSave_pressed() -> void:
	if not $NewSave/VBoxContainer/LineEdit.text == "":
		Globals.current_save_name = $NewSave/VBoxContainer/LineEdit.text
	else:
		print("Enter the save name!")
	show_submenu_page($CharacterSelect)
	$NewSave.hide()
	#Globals.save_level(0, $NewSave/LineEdit.text)


func _on_SaveLoader_no_saves_found() -> void:
	$VBoxContainer/LoadGame.disabled = true




func _on_CanceNewSave_pressed():
	$NewSave.hide()


func _on_Achivements_pressed():
	$AchivementPanel.popup_centered()


func _on_NotDone_item_selected(index):
	$AchivementPanel/Desc.text = Globals.achievements_desc[$AchivementPanel/HBoxContainer/NotDone.get_item_text(index)]


func _on_Done_item_selected(index):
	$AchivementPanel/Desc.text = Globals.achievements_desc[$AchivementPanel/HBoxContainer/Done.get_item_text(index)]


func _on_Info_pressed():
	$Account.show()


func _on_Logout_pressed():
	Firebase.Auth.remove_auth()
	Firebase.Auth.logout()
	Globals.user_data = {}
	$VBoxContainer3/Info.disabled = true
	$VBoxContainer3/Logout.disabled = true
	$VBoxContainer3/Login.disabled = false


func _on_Login_pressed():
	$LoginPanel.popup_centered()


func _on_Leaderboard_pressed():
	$Leaderboard.popup_centered()
