tool
extends EditorExportPlugin

class_name TranslationsExport
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _export_begin(features, is_debug, path, flags):
	###translation research
	if 'translations' in features:
		var dir = Directory.new()
		var pck = PCKPacker.new()
		var base_path = path.get_base_dir()
		if dir.dir_exists(base_path + '/translations/'):
			rm_dir_recursive(base_path + '/translations/')
			dir.make_dir(base_path + '/translations/')
		else:
			dir.make_dir(base_path + '/translations/')
		if dir.open("res://translations/") == OK:
			pck.pck_start(base_path + '/translations/translations.pck')
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if dir.current_is_dir():
					print("Found directory: " + file_name)
				else:
					if file_name.get_extension() == "translation":
						pck.add_file('res://translations/' + file_name.get_file(), 'res://translations/' + file_name.get_file())
						
				file_name = dir.get_next()
			pck.flush()
	###scenes research
	if 'scenes' in features:
		var dir = Directory.new()
		var pck = PCKPacker.new()
		var base_path = path.get_base_dir()
		if dir.dir_exists(base_path + '/pck/'):
			dir.rm_dir_recursive(base_path + '/pck/')
			dir.make_dir(base_path + '/pck/')
		else:
			dir.make_dir(base_path + '/pck/')
			pck.pck_start(base_path + '/pck/scenes.pck')
			var files = find_recursive("tscn", "res://")
			print(files)
			for i in files:
				pck.add_file(files[i], files[i])
			pck.flush()
		
func rm_dir_recursive(path):
	var _pth = path
	var dir = Directory.new()
	var av_dirs = ['.', '..']
	if dir.open(_pth) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() and not av_dirs.has(file_name):
				rm_dir_recursive(_pth + '/' + file_name)
			else:
				dir.remove(file_name.get_base_dir() + '/' + file_name.get_basename() + '.' + file_name.get_extension())
var _was_in_dir = []
func find_recursive(extension, search_dir):
	if not _was_in_dir.has(search_dir):
		_was_in_dir.append(search_dir)
		print("Scanning: " + search_dir + " for: ." + extension + " files...")
		var _ret = []
		var av_dirs = ['.', '..', '.git', '.import']
		var _ext = extension
		var dir = Directory.new()
		if dir.open(search_dir) == OK:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if dir.current_is_dir() and not av_dirs.has(file_name):
					_ret += find_recursive(_ext, search_dir + '/' + file_name)
				else:
					if file_name.get_extension() == _ext:
						print("Adding: " + file_name.get_base_dir() + '/' + file_name.get_basename() + '.' + _ext)
						_ret.append(file_name.get_base_dir() + '/' + file_name.get_basename() + '.' + _ext)
					file_name = dir.get_next()
			return _ret
		else:
			find_recursive(extension, search_dir.get_base_dir())
			return null
	
