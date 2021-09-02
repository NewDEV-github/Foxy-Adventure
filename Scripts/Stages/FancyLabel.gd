extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.has_environment("USERNAME"):
		text = "You are sooo cute :3, %s!" % [OS.get_environment("USERNAME")]
	else:
		text = "You are sooo cute :3"
