extends RichTextLabel

enum Modes {PERCENTAGE, CHARACTERS}
signal printed
const CHARACTER_MODE_THRESHOLD_DENOMINATOR = 8.0

export(Modes) var mode = Modes.PERCENTAGE
export(float) var volume_db = 1.0
export(String) var audio_bus = "Master"

var sounds: Array = []
var print_on: bool = false
var print_speed: float = 1.0
var fast_print_speed: float = 2.0
var accumulation: float = 0.0
var chunk_size = 1.0
onready var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	audio_player.bus = audio_bus
	add_child(audio_player)


func print_message(message: String, speed: float = 1.0, sound_paths: Array = ["res://addons/rpg_text_boxes/sine.wav", "res://addons/rpg_text_boxes/vowel.wav"]):
	print_speed = speed
	fast_print_speed = 2.0 * speed
	
	for x in sound_paths:
		sounds.append(load(x))
	
	if message.length() != 0:
		text = message
		print_on = true
	
	percent_visible = 0.0


func _process(delta):
	if print_on:
		randomize()
		sounds.shuffle()
		audio_player.volume_db = volume_db
		match mode:
			Modes.PERCENTAGE:
				accumulation += delta * print_speed
				
				if accumulation >= 0.01 * print_speed:
					percent_visible += accumulation
					
					audio_player.stream = sounds[0]
					audio_player.pitch_scale = 1.1 - (randf() * 0.2)
					audio_player.play()
					
					accumulation = 0.0
			Modes.CHARACTERS:
				chunk_size = (1.0 / get_total_character_count()) * print_speed
				accumulation += delta * chunk_size
				
				if accumulation >= (1.0 + randf()) / get_total_character_count():
					percent_visible += accumulation
					
					audio_player.stream = sounds[0]
					audio_player.pitch_scale = 1.1 - (randf() * 0.2)
					audio_player.play()
					
					accumulation = 0.0
		
		if percent_visible >= 1.0:
			print_on = false

func fast_speed():
	print_speed = fast_print_speed


func normal_speed():
	print_speed = fast_print_speed / 2
