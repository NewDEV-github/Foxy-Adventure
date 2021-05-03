extends Node
var music_instances = {}
var sfx_instances = {}
var menu_music_events = ['music_gekagd']
var sfx_music_events = ['stage1', 'stage2']
var credits_music_events = ['credits1', 'credits2']
var stages_music_events = ['sound_coin', 'sound_explode', 'sound_hit', 'sound_jump', 'sound_shoot']
var bank_list = ['Master.strings.bank', 'Master.bank']
func _ready():
	print("Initializing FMOD...")
	###initializing
	Fmod.set_software_format(0, Fmod.FMOD_SPEAKERMODE_DEFAULT, 0)
	Fmod.init(1024, Fmod.FMOD_STUDIO_INIT_LIVEUPDATE, Fmod.FMOD_INIT_NORMAL)
	###loading banks
	for i in bank_list:
		var bank = "res://assets/Audio/Banks/" + i
		Fmod.load_bank(bank, Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
	###creating sound instances
	for i in stages_music_events:
		music_instances[i] = Fmod.create_event_instance("event:/" + i)
	for i in credits_music_events:
		music_instances[i] = Fmod.create_event_instance("event:/" + i)
	for i in menu_music_events:
		music_instances[i] = Fmod.create_event_instance("event:/" + i)
	for i in sfx_music_events:
		sfx_instances[i] = Fmod.create_event_instance("event:/" + i)
	Fmod.wait_for_all_loads()
	play_event_music('credits2')
func play_event_music(event_name, oneshot=false):
	print("Starting event at: event:/" + event_name)
	Fmod.add_listener(0, self)
	Fmod.start_event(music_instances[event_name])

func play_event_sfx(event_name, oneshot=false):
	print("Starting event at: event:/" + event_name)
	Fmod.add_listener(0, self)
	Fmod.start_event(sfx_instances[event_name])

func stop_event_sfx(event_name):
	print("Stopping event at: event:/" + event_name)
	Fmod.stop_Event(sfx_instances[event_name], Fmod.FMOD_STUDIO_STOP_ALLOWFADEOUT)
func stop_event_music(event_name):
	print("Stopping event at: event:/" + event_name)
	Fmod.stop_event(music_instances[event_name], Fmod.FMOD_STUDIO_STOP_ALLOWFADEOUT)
func set_sfx_volume_db(volume):
	for i in sfx_instances:
		Fmod.set_event_volume(i, volume)
		pass
func set_music_volume_db(volume):
	for i in music_instances:
		Fmod.set_event_volume(i, volume)

func set_all_volume_db(volume):
	set_music_volume_db(volume)
	set_sfx_volume_db(volume)

