extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var log_file = File.new()

# Called when the node enters the scene tree for the first time.
func make_log_scene():
	var save
	var packed_scene = PackedScene.new()
	packed_scene.pack(get_tree().get_current_scene())
	save = ResourceSaver.save("user://log_scene.tscn", packed_scene)

func make_game_log():
	log_file.open('user://game_log.log', File.WRITE)
	log_file.store_line(str(Globals.return_log_values()))
	log_file.close()
