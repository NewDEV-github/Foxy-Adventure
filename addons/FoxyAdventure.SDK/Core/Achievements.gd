extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func add_achievement(name, desc):
	Globals.all_achievements.append(name)
	Globals.achievements_desc[name] = desc

func add_achievement_requirement(name, variable, value):
	Globals.custom_achievements_requirements[name][variable] = value
