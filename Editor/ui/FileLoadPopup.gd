extends FileDialog


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

signal stage_file_selected
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_dir = Globals.level_path
func show_popup():
	popup_centered()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_FileLoadPopup_file_selected(path: String) -> void:
	emit_signal("stage_file_selected", path)
