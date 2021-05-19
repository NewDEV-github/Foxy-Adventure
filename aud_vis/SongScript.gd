extends AudioStreamPlayer

# Add this script to your music player

func _ready():
	yield(get_tree().create_timer(5.0), "timeout")
	play()
