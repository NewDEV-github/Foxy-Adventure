extends FileDialog


# Declare member variables here. Examples:
# var a: int = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_dir = Globals.level_path
func show_popup():
	popup_centered()

