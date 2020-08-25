extends Control
var tekst = "Hello World"
var world_scene
var website
var music_fmod
#var discord_rpc = DISCORD_RPC.new()
var day = OS.get_date().day
var month = OS.get_date().month
var nsfw_connection
onready var world_list = Globals.worlds
onready var ntf_imgs = [
	'res://Graphics/NewTheFox/1.png',
	'res://Graphics/NewTheFox/2.png',
	'res://Graphics/NewTheFox/3.png',
	'res://Graphics/NewTheFox/4.png',
	'res://Graphics/NewTheFox/5.png',
	'res://Graphics/NewTheFox/6.png',
	'res://Graphics/NewTheFox/7.png',
	'res://Graphics/NewTheFox/8.png',
	'res://Graphics/NewTheFox/9.png',
	'res://Graphics/NewTheFox/10.png',
	'res://Graphics/NewTheFox/11.png',
	'res://Graphics/NewTheFox/recolour1.png',
	'res://Graphics/NewTheFox/recolour2.png',
	'res://Graphics/NewTheFox/recolour3.png',
	'res://Graphics/NewTheFox/recolour4.png',
	'res://Graphics/NewTheFox/recolour5.png',
]
onready var bs_imgs = [
	'res://Graphics/BabySonadow/babysonadow.png',
]
# Called when the node enters the scene tree for the first time.
func _ready():
#	load_easterregg_animation('ntf')
	var music_path = "res://Audio/BGM/main_menu.ogg"
#	# register listener
	Fmod.add_listener(0,self)
	Fmod.load_file_as_music(music_path)
	Globals.fmod_sound_music_instance = Fmod.create_sound_instance(music_path)
	Fmod.play_sound(Globals.fmod_sound_music_instance)
	$SelectWorld/WorldList.add_item(tr("KEY_MAGIC_FOREST"))
	DLCLoader.load_all_dlcs()
	for world_name in world_list:
		$SelectWorld/WorldList.add_item(tr(world_name))
	Directory.new().make_dir('user://logs/')
	nsfw_connection = Globals.connect("nsfw", self, "globals_nsfw_changed")
	if day == 21 and month == 6:
		$IMG_0008.hide()
		load_easterregg_animation('ntf')
		$Label.set_text(tr("KEY_HAPPY_BDAY") + ' "Foxy Adventure"')
	elif day == 17 and month == 2:
		$IMG_0008.hide()
		load_easterregg_animation('ntf')
		$Label.set_text(tr("KEY_HAPPY_BDAY") + ' "NewTheFox" - Kocham cię ~sonic')
	elif day == 25 and month == 3:
		$IMG_0008.hide()
		load_easterregg_animation('ntf')
		$Label.set_text(tr("KEY_HAPPY_BDAY") + ' "NewTheFox" - Kocham cię ~sonic')
	elif day == 14 and month == 9:
		$IMG_0008.hide()
		load_easterregg_animation('ntf')
		$Label.set_text(tr("KEY_HAPPY_BDAY") + ' Gekon aka "GeKaGD"')
	elif day == 22 and month == 12:
		$IMG_0008.hide()
		load_easterregg_animation('bs')
		$Label.set_text(tr("KEY_HAPPY_BDAY") + ' thugpro420 aka "Baby Sonadow"')
	BackgroundLoad.play_start_transition = true
	get_tree().paused = false
#	$AnimationPlayer.play('end_transition')
	print('Game launched successfully!\n')
	$Control.load_settings()

func globals_nsfw_changed(nsfw_enabled:bool):
	if nsfw_enabled:
		$IMG_0008.texture = load(str("res://Graphics/icon.png"))
	else:
		$IMG_0008.texture = load(str("res://Graphics/Titles/IMG_0008.jpeg"))

func load_easterregg_animation(name_:String):
	randomize()
	if name_ == 'ntf':
		$IMG_0009.texture = load(str(ntf_imgs[randi()%ntf_imgs.size()]))
	elif name_ == 'bs':
		$IMG_0009.texture = load(str(bs_imgs[randi()%bs_imgs.size()]))
func _on_World1_pressed():
	$SelectWorld.popup_centered()
#	$SelectWorld.show()
func _on_Options_pressed():
	$Control.popup_centered()


func _on_Quit_pressed():
	get_tree().quit()


func _on_Website_pressed():
	website = OS.shell_open('https://www.sonadow-rpg.ml/')


func _on_Options2_pressed():
	BackgroundLoad.load_scene('res://Scenes/Credits.tscn')


func _on_WorldList_item_selected(index):
	if index == 0:
		Globals.world = "res://Scenes/Maps/MainWorld.tscn"
	if Globals.selected_character == null:
		$CharacterSelect.popup_centered()
	else:
		BackgroundLoad.load_scene(str(Globals.world))



func _on_Menu_tree_exiting():
	Fmod.stop_sound(Globals.fmod_sound_music_instance)
