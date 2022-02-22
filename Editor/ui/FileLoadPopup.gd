extends FileDialog


# Declare member variables here. Examples:
# var a: int = 2

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	if str(Globals.level_path).begins_with("user://"):
#		current_dir = str(Globals.level_path).replace("user://", str(OS.get_user_data_dir()) + "/")
func show_popup():
	popup_centered()

