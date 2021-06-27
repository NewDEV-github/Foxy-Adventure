extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func add_command(name, target, target_name=null):
	var file = File.new()
	if file.file_exists("res://addons/quentincaffeino-console/src/Command/CommandService.gd"):
		Console.addCommand(name, target, target_name)
	else:
		print("That command will only work in game!")
