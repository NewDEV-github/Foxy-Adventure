extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_project_id = -1
var all_project_data = []
var dir = Directory.new()
var f = File.new()
var cfg = ConfigFile.new()
var avoid_files_and_dirs = [".", ".."]
# Called when the node enters the scene tree for the first time.
func _ready():
	scan_projects()


func scan_projects():
	all_project_data = []
	dir.open("user://level_data/")
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while not file_name == "":
		if not avoid_files_and_dirs.has(file_name):
			if dir.current_is_dir():
				if check_path_for_project("user://level_data/" + file_name):
					add_project("user://level_data/" + file_name)
		file_name = dir.get_next()

func add_project(path:String):
	var project_data = read_project_data(path)
	$VBoxContainer2/ProjectList.add_item(project_data["name_org"])
	all_project_data.append(project_data)

func read_project_data(path:String):
	cfg.load(path + "/configuration/main.cfg")
	var tmp_dict = {}
	for i in cfg.get_section_keys("info"):
		tmp_dict[i] = cfg.get_value("info", i)
	return tmp_dict

func check_path_for_project(path:String):
	return f.file_exists(path + "/configuration/main.cfg")

func _on_ProjectList_nothing_selected():
	$VBoxContainer2/ProjectList.unselect_all()
	current_project_id = -1

func _on_ProjectList_item_selected(index):
	current_project_id = index

func edit_existing_project(project_path:String):
	$"../../Node2D".load_stage(project_path)
	hide()

func _on_ProjectList_item_activated(index):
	current_project_id = index
#	edit_existing_project("user://level_data/")


func _on_Edit_pressed():
	var project_data = all_project_data[current_project_id]
	edit_existing_project("user://level_data/" + project_data["name"])

func _process(delta):
	if current_project_id == -1:
		$VBoxContainer/Delete.disabled = true
		$VBoxContainer/Edit.disabled = true
	else:
		$VBoxContainer/Delete.disabled = false
		$VBoxContainer/Edit.disabled = false

func _on_Delete_pressed():
	var project_data = all_project_data[current_project_id]
	remove_project_data("user://level_data/" + project_data["name"])
	$VBoxContainer2/ProjectList.clear()
	scan_projects()
func remove_project_data(path:String):
	dir.open(path)
	dir.list_dir_begin()
	var n = dir.get_next()
	while not n == '':
		if not avoid_files_and_dirs.has(n):
			if dir.current_is_dir():
#				print(path + "/" + n.get_basename())
				remove_project_data(path + "/" + n.get_basename() +"/")
			else:
				dir.remove(path + "/" + n.get_file())
		n = dir.get_next()
func _on_New_pressed():
	$"../navbar".popup_new_file_window()
	hide()
