extends RichTextLabel
#################################################################
### The super awesome Tag processing Label - by meloonicscorp ###
#################################################################
# v1.0
# 2020-07-28
# Godot v3.2.2stable official
#
# This modifies RichTextLabel allows you to display icons in your text, using BBCode.
# This demo shows how the Label changes certain inputs to icons and adapts to changing controllers.
# You can make your own Tag-Syntax and add new devices in TagProcessor.gd
# I hope this helps, have fun with it :^)


#reuse this scene everywhere in the game where you need icons to be displayed.
#you can use it for dialog, UI text and basically anything that involves inputs and text.

#this bool can be used to turn tag-processing off. 
#idk why you would want that, but I think it's nice for demonstration purposes.
export var process_tags = true

#this is a custom input field for the inspector. Make sure to ONLY USE THIS FIELD to add a String to the label, 
#otherwise it won't work! If you want to assign a String in code you can do so via set_original_text()
#Pro Tip: for line-breaks use " \n ". See also: https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_format_string.html
export(String, MULTILINE) var original_text = "" setget set_original_text, get_original_text

#this variable doesn't have a setter, since it will be updated along with original_text.
var processed_text setget ,get_processed_text

#checks for the controller, that has last been connected.
var current_device = 0


func _ready():
	#if BBCode ain't enabled, this whole process won't work.
	bbcode_enabled = true
	
	#Using this method, the Label will adapt to changing controllers.
	Input.connect("joy_connection_changed", self, "new_device")


func new_device(device, connected):
	current_device = device
	update_text(Input.get_joy_name(current_device))
	print("device: " + Input.get_joy_name(current_device))


func update_text(device_name):
	
	var new_text = original_text
	if process_tags:
		new_text = TagProcessor.process_tags(new_text, device_name)
	processed_text = new_text
	
	#after replacing the tags, this redraws the string on screen.
	bbcode_text = processed_text

########### SETTERS & GETTERS:

func set_original_text(new_text):
	original_text = new_text
	update_text(Input.get_joy_name(0))

func get_original_text():
	return original_text

func get_processed_text():
	return processed_text
