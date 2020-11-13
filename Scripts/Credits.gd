extends Control
var date = OS.get_date()

# Declare member variables here. Examples:
# var a = 2
var copyright = "[center]\nPowered by Godot Engine\ngame_name - Copyright 2020 - "\
	+ str(OS.get_date().year) + " - New DEV\nGodot Engine - Copyright 2020 - " +\
	str(OS.get_date().year) + " - Godot Engine Contributors[/center]\n#SilnyGekon"

# Called when the node enters the scene tree for the first time.
func _ready():
	var f = File.new
	$HBoxContainer/RichTextLabel.bbcode_text += copyright
	$AnimationPlayer.play("credits")

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://Scenes/Menu.tscn")
