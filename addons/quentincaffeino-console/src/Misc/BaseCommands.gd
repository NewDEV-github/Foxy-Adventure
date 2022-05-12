
extends Reference


# @var  Console
var _console


# @param  Console  console
func _init(console):
	self._console = console

	self._console.add_command('echo', self._console, 'write')\
		.set_description('Prints a string.')\
		.add_argument('text', TYPE_STRING)\
		.register()

	self._console.add_command('history', self._console.History, 'print_all')\
		.set_description('Print all previous commands used during the session.')\
		.register()

	self._console.add_command('commands', self, '_list_commands')\
		.set_description('Lists all available commands.')\
		.register()
	self._console.add_command('send_log', self, '_send_log')\
		.set_description('Sends log to developer\'s database.')\
		.register()
	self._console.add_command('update_score', self, '_update_score')\
		.set_description('SUpdates score for given user uid.')\
		.add_argument('score', TYPE_INT)\
		.add_argument('uid', TYPE_STRING)\
		.register()
	self._console.add_command('help', self, '_help')\
		.set_description('Outputs usage instructions.')\
		.add_argument('command', TYPE_STRING)\
		.register()
	self._console.add_command('change_scene', self, '_change_scene')\
		.set_description('Changes scene.')\
		.add_argument('path', TYPE_STRING)\
		.register()

	self._console.add_command('quit', self, '_quit')\
		.set_description('Exit application.')\
		.register()

	self._console.add_command('clear', self._console)\
		.set_description('Clear the terminal.')\
		.register()

	self._console.add_command('version', self, '_version')\
		.set_description('Shows engine version.')\
		.register()

	self._console.add_command('fps_max', Engine, 'set_target_fps')\
		.set_description('The maximal framerate at which the application can run.')\
		.add_argument('fps', self._console.IntRangeType.new(10, 1000))\
		.register()
	self._console.add_command('Globals.set', self, '_set_globals_variable')\
		.set_description('Set variable in Globals')\
		.add_argument('property', TYPE_STRING)\
		.add_argument('variable', TYPE_STRING)\
		.register()
	self._console.add_command('reload_scene', self, '_reload_scene')\
		.set_description('Reloads scene')\
		.register()


# Display help message or display description for the command.
# @param    String|null  command_name
# @returns  void
func _help(command_name = null):
	if command_name:
		var command = self._console.get_command(command_name)

		if command:
			command.describe()
		else:
			self._console.Log.warn('No help for `' + command_name + '` command were found.')

	else:
		self._console.write_line(\
			"Type [color=#ffff66][url=help]help[/url] <command-name>[/color] show information about command.\n" + \
			"Type [color=#ffff66][url=commands]commands[/url][/color] to get a list of all commands.\n" + \
			"Type [color=#ffff66][url=quit]quit[/url][/color] to exit the application.")


# Prints out engine version.
# @returns  void
func _version():
	self._console.write_line(Engine.get_version_info())


# @returns  void
func _list_commands():
	for command in self._console._command_service.values():
		var name = command.getName()
		self._console.write_line('[color=#ffff66][url=%s]%s[/url][/color]' % [ name, name ])

func _update_score(score, uid):
	ApiScores.update_score(uid, score)
	self._console.write_line("Score for %s was updated :3" % [uid])
func _send_log():
#	OS.shell_open(Globals.install_base_path + "send_log/send_log")
	ApiLogs.send_debug_log_to_database()
	yield(ApiLogs, "recived_log_id")
	self._console.write_line('Your log id is: (0)' + str(ApiLogs.tmp_log_id))
func _quit():
	self._console.Log.warn('Quitting application...')
	self._console.get_tree().quit()
func _change_scene(path):
	self._console.Log.warn('Changing scene to ' + path + '...')
	BackgroundLoad.get_node("bgload").load_scene(path)

func _reload_scene():
	Globals.reload_scene()

func _set_globals_variable(property, value):
	Globals.set(property, value)
