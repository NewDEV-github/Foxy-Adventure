extends Control
var tekst = "Hello World"
var world_scene
var website
var current_submenu_page
export (bool) var is_android
#onready var editor_lib = load("res://bin/gdexample.gdns").new()
#var discord_rpc = DISCORD_RPC.new()
var day = OS.get_date().day
var month = OS.get_date().month
var nsfw_connection
onready var world_list = Globals.worlds
onready var ntf_imgs = [
	'res://Graphics/NewTheFox/2.png',
	'res://Graphics/NewTheFox/5.png',
	'res://Graphics/NewTheFox/8.png',
	'res://Graphics/NewTheFox/recolour3.png',
	'res://Graphics/NewTheFox/recolour4.png',
	'res://Graphics/NewTheFox/recolour5.png',
]
onready var bs_imgs = [
	'res://Graphics/BabySonadow/babysonadow.png',
]
# Called when the node enters the scene tree for the first time.
func _ready():
	if str(OS.get_name()) == "Android" and not is_android:
		get_tree().change_scene("res://Scenes/Menu_android.tscn")
	$version_label.bbcode_text = Globals.construct_game_version()
	Globals.selected_character = null
	Globals.character_path = null
	var lem = LevelEditorManager.new()
	lem.install_editor("user://test.zip")
	$tails.hide()
	if File.new().file_exists("user://milestailsprower.txt"):
		$tails.show()
		$Label.set_text(tr("KEY_HAPPY_BDAY") + ' Miles "Tails" Prower')
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
		$SelectWorld/WorldList.add_item(tr(world_name))
	Directory.new().make_dir('user://logs/')
	if day == 21 and month == 6:
		$IMG_0008.hide()
		load_easterregg_animation('ntf')
		$Label.set_text(tr("KEY_HAPPY_BDAY") + ' "Foxy Adventure"')
	elif day == 17 and month == 2:
		$IMG_0008.hide()
		load_easterregg_animation('ntf')
		$Label.set_text(tr("KEY_HAPPY_BDAY") + ' "NewTheFox" ')
	elif day == 25 and month == 3:
		$IMG_0008.hide()
		load_easterregg_animation('ntf')
		$Label.set_text(tr("KEY_HAPPY_BDAY") + ' "NewTheFox" ')
	elif day == 14 and month == 9:
		$IMG_0008.hide()
		load_easterregg_animation('ntf')
		$Label.set_text(tr("KEY_HAPPY_BDAY") + ' Gekon aka "GeKaGD"')
	elif day == 22 and month == 12:
		$IMG_0008.hide()
		load_easterregg_animation('bs')
		$Label.set_text(tr("KEY_HAPPY_BDAY") + ' thugpro420 aka "Baby Sonadow"')
	elif day == 16 and month == 10:
		$IMG_0008.hide()
#		load_easterregg_animation('bs')
		$Label.set_text(tr("KEY_HAPPY_BDAY") + ' Miles "Tails" Prower')
	elif day == 16 and month == 4:
		$IMG_0008.hide()
#		load_easterregg_animation('bs')
		$Label.set_text(tr("KEY_HAPPY_BDAY") + ' Erwin')
	BackgroundLoad.play_start_transition = true
	get_tree().paused = false
#	$AnimationPlayer.play('end_transition')
	print('Game launched successfully!\n')

func show_submenu_page(page):
	if current_submenu_page != null:
		page.show()
		if not current_submenu_page == page:
			current_submenu_page.hide()
	else:
		page.show()
		current_submenu_page = page
func load_easterregg_animation(name_:String):
	randomize()
	if name_ == 'ntf':
		$IMG_0009.texture = load(str(ntf_imgs[randi()%ntf_imgs.size()]))
	elif name_ == 'bs':
		$IMG_0009.texture = load(str(bs_imgs[randi()%bs_imgs.size()]))

func _on_Options_pressed():
	show_submenu_page($Control)


func _on_Quit_pressed():
	get_tree().quit()


func _on_Website_pressed():
	website = OS.shell_open(SharedLibManager.website_project.get_data())
#	pass     


func _on_Options2_pressed():
	get_tree().change_scene('res://Scenes/Credits.tscn')


func _on_WorldList_item_selected(index):
	pass

func custom_level_research():
	for path in Globals.levels_scan_path:
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



func _on_Menu_tree_exiting():
	pass


func _on_Level_Editor_pressed():
	var lvm = LevelEditorManager.new()
	if !lvm.execute_editor():
		lvm.download_editor()
func _on_Feedback_pressed():
	$Feedback.send_feedback()


func _on_NewGame_pressed() -> void:
	show_submenu_page($NewSave)


func _on_LoadGame_pressed() -> void:
	show_submenu_page($SaveLoader)


func _on_CreateNewSave_pressed() -> void:
	if not $NewSave/LineEdit.text == "":
		Globals.current_save_name = $NewSave/LineEdit.text
	else:
		print("Enter the save name!")
	show_submenu_page($CharacterSelect)
	$NewSave.hide()
	#Globals.save_level(0, $NewSave/LineEdit.text)


func _on_SaveLoader_no_saves_found() -> void:
	$VBoxContainer/LoadGame.disabled = true




func _on_CanceNewSave_pressed():
	$NewSave.hide()
