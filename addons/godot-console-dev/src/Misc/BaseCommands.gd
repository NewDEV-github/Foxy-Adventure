
extends Reference


func _init():
	Console.addCommand('echo', Console, 'write')\
		.setDescription('Prints a string.')\
		.addArgument('text', TYPE_STRING)\
		.register()

	Console.addCommand('history', Console.History, 'printAll')\
		.setDescription('Print all previous commands used during the session.')\
		.register()

	Console.addCommand('commands', Console._rootGroup, 'printAll')\
		.setDescription('Lists all available commands.')\
		.register()

	Console.addCommand('help', self)\
		.setDescription('Outputs usage instructions.')\
		.addArgument('command', TYPE_STRING)\
		.register()

	Console.addCommand('dump_mem', OS, 'dump_memory_to_file')\
		.setDescription('Dumps memory to file')\
		.addArgument('file', TYPE_STRING)\
		.register()

	Console.addCommand('dump_res', OS, 'dump_resources_to_file')\
		.setDescription('Dumpsresources to file')\
		.addArgument('file', TYPE_STRING)\
		.register()

	Console.addCommand('quit', self)\
		.setDescription('Exit application.')\
		.register()

	Console.addCommand('setGlobalVariable', self)\
		.setDescription('Sets given variable from "Globals.gd" script to given value')\
		.addArgument('variable', TYPE_STRING)\
		.addArgument('value', TYPE_STRING)\
		.register()

	Console.addCommand('setEngineVariable', self)\
		.setDescription('Sets given Operating System variable to given value')\
		.addArgument('variable', TYPE_STRING)\
		.addArgument('value', TYPE_STRING)\
		.register()

	Console.addCommand('setOSVariable', self)\
		.setDescription('Sets given Engine script to given value')\
		.addArgument('variable', TYPE_STRING)\
		.addArgument('value', TYPE_STRING)\
		.register()

	Console.addCommand('changeScene', self)\
		.setDescription('Changes scene to provided')\
		.addArgument('path', TYPE_STRING)\
		.register()

	Console.addCommand('clear', Console)\
		.setDescription('Clear the terminal.')\
		.register()

	Console.addCommand('version', self)\
		.setDescription('Shows engine vesion.')\
		.register()


	Console.addCommand('load_scene', BackgroundLoad, 'load_scene')\
		.setDescription('Brings you to another scene.')\
		.addArgument('path', TYPE_STRING)\
		.register()
		
		
	Console.addCommand('fps_max', Engine, 'set_target_fps')\
		.setDescription('The maximal framerate at which the application can run.')\
		.addArgument('fps', Console.IntRange.new(10, 1000))\
		.register()


# Display help message or display description for the command.
# @param  string|null  command
static func help(command = null):
	if command:
		command = Console.getCommand(command)
		if !command:
			Console.Log.warn('No such command.')
			return
		command.describe()
	else:
		Console.writeLine(\
			"Type [color=#ffff66][url=help]help[/url] <command-name>[/color] show information about command.\n" + \
			"Type [color=#ffff66][url=commands]commands[/url][/color] to get a list of all commands.\n" + \
			"Type [color=#ffff66][url=quit]quit[/url][/color] to exit the application.")


# Prints out engine version.
static func version():  # void
	Console.writeLine(Engine.get_version_info())


# Quitting application.
static func quit():  # void
	Console.Log.warn('Quitting application...')
	Console.get_tree().quit()

static func changeScene(path:String):
	BackgroundLoad.load_scene(path)

static func setGlobalVariable(variable, value):
	Globals.set_variable(variable, value)

static func setEngineVariable(variable, value):
	Engine.set(variable, value)

static func setOSVariable(variable, value):
	OS.set(variable, value)
