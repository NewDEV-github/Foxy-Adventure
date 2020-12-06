extends HTTPRequest

class_name LevelEditorManager
signal editor_installed
var dir = Directory.new()
var temp_download_path = "user://temp/"
func generate_download_link() -> String:
	var tag = ""
	var os_shorts = {
		"Windows": "win",
		"X11": "x11"
	}
	var os_short
	if os_shorts.has(OS.get_name()):
		os_short = os_shorts[OS.get_name()]
	var bits = Globals.bits
#	var tag_name = "Release from "+ tag
	var request_url = "https://github.com/NewDEV-github/Foxy-Adventure/releases/download/latest/build-%s-%s.zip" % [os_short, bits]
	print(request_url)
	return request_url

func execute_editor():
	var file = File.new()
	if file.file_exists(Globals.install_base_path + "editor.exe") && OS.get_name() == "Windows":
		OS.execute(Globals.install_base_path + "editor.exe", [], false)
		return true
	elif file.file_exists(Globals.install_base_path + "editor.%s" % [Globals.bits]) && OS.get_name() == "X11":
		OS.execute(Globals.install_base_path + "editor.%s" % [Globals.bits], [], false)
		return true
	else:
		return false
func _init():
	dir.open("user://")
	dir.make_dir("temp")
	download_file = temp_download_path + generate_download_link().get_basename() + ".zip"
func download_editor(auto_install:bool = true):
	request(generate_download_link())
	if auto_install:
		install_editor()
func install_editor(download_path:String = temp_download_path, install_path:String = Globals.install_base_path, clear_cache:bool = true):
	unzip(download_path, install_path)
	if clear_cache:
		var dir = Directory.new()
		dir.remove(download_path)
var storage_path
var zip_file
func unzip(sourceFile,destination):
	zip_file = sourceFile
	storage_path = destination
	var gdunzip = load('res://Scripts/gdunzip.gd').new()
	var loaded = gdunzip.load(zip_file)
	if !loaded:
		print('- Failed loading zip file')
		return false
	#ProjectSettings.load_resource_pack(zip_file)
	var i = 0
	for f in gdunzip.files:
		unzip_file(f)
func unzip_file(fileName):
	var readFile = File.new()
	if readFile.file_exists("res://"+fileName):
		readFile.open(("res://"+fileName), File.READ)
		var content = readFile.get_buffer(readFile.get_len())
		readFile.close()
		var base_dir = storage_path + fileName.get_base_dir()
		var dir = Directory.new()
		dir.make_dir(base_dir)
		var writeFile = File.new()
		writeFile.open(storage_path + fileName, File.WRITE)
		writeFile.store_buffer(content)
		writeFile.close()
		emit_signal("editor_installed", true)
