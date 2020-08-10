extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var download_path = str(OS.get_executable_path())

# Called when the node enters the scene tree for the first time.
func _ready():
	$audio.set_download_file('user://audio.zip')
	$graphics.set_download_file('user://graphics.zip')
	$translations.set_download_file('user://translations.zip')
#	OS.request_permissions()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
