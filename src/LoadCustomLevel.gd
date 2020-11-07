extends Node

func load_stage(filename:String):
	if has_node("Level"):
		remove_child(get_node("Level"))
	var full_path = GlobalsEditor.saved_levels_root_path + filename + ".tscn"
	var scn = load(full_path).instance()
	add_child(scn)
