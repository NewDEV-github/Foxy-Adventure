extends WindowDialog

var save_file_names = []
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	popup()
	var dir = Directory.new()
	if dir.open("user://") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				if file_name.get_extension() == "cfg" and file_name.begins_with("save_"):
					save_file_names.append(get_save_name(file_name.get_basename()))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	for i in save_file_names:
		$ItemList.add_item(i)

func get_save_name(file_name:String):
	return file_name.trim_prefix("save_")
#	var regex = RegEx.new()
#	regex.compile("save_(\\s+).cfg")
#	var result = regex.search(file_name)
#	if result:
#		return result.get_string()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_ItemList_item_selected(index: int) -> void:
	var save_name = $ItemList.get_item_text(index)
	Globals.load_level(save_name)
