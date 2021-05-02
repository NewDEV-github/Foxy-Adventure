tool
extends EditorPlugin

class PythonExportPlugin:
	extends EditorExportPlugin
	func scan(path:String) -> Array:
		var file_name := ""
		var files := []
		var dir = Directory.new()
		if dir.open(path) != OK:
			print("Failed to open:"+path)
		else:
			dir.list_dir_begin(true)
			file_name = dir.get_next()
			while file_name!="":
				if dir.current_is_dir():
					var sub_path = path+"/"+file_name
					files += scan(sub_path)
				else:
					print("Found file: " + path+"/"+file_name)
					var name := path+"/"+file_name
					files.push_back(name)
				file_name = dir.get_next()
			dir.list_dir_end()
		return files

	func _add_python_addons(plat) -> void:
		var files_c = [
			"res://addons/videodecoder.gdnlib",
			"res://bin/gdsdk/activity.gdns",
			"res://bin/gdsdk/activity_assets.gdns",
			"res://bin/gdsdk/activity_manager.gdns",
			"res://bin/gdsdk/activity_party.gdns",
			"res://bin/gdsdk/activity_secrets.gdns",
			"res://bin/gdsdk/activity_timestamps.gdns",
			"res://bin/gdsdk/core.gdns",
			"res://bin/gdsdk/discord.gd",
			"res://bin/gdsdk/discord_game_sdk.gdnlib",
			"res://bin/gdsdk/image_dimensions.gdns",
			"res://bin/gdsdk/image_handle.gdns",
			"res://bin/gdsdk/image_manager.gdns",
			"res://bin/gdsdk/party_size.gdns",
			"res://bin/gdsdk/presence.gdns",
			"res://bin/gdsdk/relationship.gdns",
			"res://bin/gdsdk/relationship_manager.gdns",
			"res://bin/gdsdk/user.gdns",
			"res://bin/gdsdk/user_manager.gdns",
			"res://bin/gitapi/git_api.gdnlib",
			"res://bin/gitapi/git_api.gdns",
			"res://icon.png",
			"res://pythonscript.gdnlib",
			"res://default_bus_layout.tres",
			"res://default_env.tres",
			#"res://project.godot"
		]
		var files = scan('res://assets')
		files += files_c
		files += scan("res://addons/godot-firebase")
		files += scan("res://addons/http-sse-client")
		files += scan("res://addons/textureRectUrl")
		files += scan("res://addons/silicon.util.custom_docs")
		files += scan("res://addons/pythonscript_repl")
		files += scan("res://addons/python-export")
		if plat == "win":
			files += scan('res://addons/pythonscript/windows-64')
			files += scan("res://bin/gitapi/win64")
			files += scan("res://bin/gdsdk/windows-64")
			files += scan("res://addons/bin/win64")
		elif plat == "x11":
			files += scan("res://bin/gitapi/x11")
			files += scan("res://bin/gdsdk/linux-64")
			files += scan("res://addons/bin/x11")
			files += scan('res://addons/pythonscript/x11-64')
		elif plat == "osx":
			files += scan('res://addons/pythonscript/osx-64')
			files += scan("res://addons/bin/osx")
			files += scan("res://bin/gdsdk/osx-64")
			files += scan("res://bin/gitapi/osx")
		for python_file in files:
			var file = File.new()
			file.open(python_file, File.READ)
			var buff = file.get_buffer(file.get_len())
			file.close()
			add_file(python_file,buff,false)
			print('File added: ' + python_file)
	func _process_hooks(hooks_path: String, args: Array) -> void:
		var dir = Directory.new()
		dir.make_dir(hooks_path)
		if dir.open(hooks_path) == OK:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != '':
				if not dir.current_is_dir() and file_name.ends_with('.gd'):
					var hook = load(dir.get_current_dir() + "/" + file_name)
					hook.callv('process', args)
				file_name = dir.get_next()
		else:
			pass
		print("Hook processed")
	func _process_start_hooks(features: PoolStringArray, debug: bool, path: String, flags: int) -> void:
		print("Start hook is being processed")
		_process_hooks('res://addons/python-export/start_hook', [features, debug, path, flags])
	func _process_end_hooks() -> void:
		print("End hook is being processed")
		_process_hooks('res://addons/python-export/end_hook', [])
	func _export_begin(features: PoolStringArray, debug: bool, path: String, flags: int) -> void:
		_process_start_hooks(features, debug, path, flags)
		if 'Windows' in features:
			print("Exporting for Windows")
			_add_python_addons("win")
		elif 'X11' in features:
			print("Exporting for X11")
			_add_python_addons("x11")
		elif 'OSX' in features:
			print("Exporting for OSX")
			_add_python_addons("osx")
	func _export_end() -> void:
		_process_end_hooks()
		pass

func _init():
	add_export_plugin(PythonExportPlugin.new())

func _enter_tree():
	pass

func _exit_tree():
	pass
