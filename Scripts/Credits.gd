extends Control
# Called when the node enters the scene tree for the first time.
func _ready():
	var f = File.new()
	f.open("gekagd.txt", File.READ)
	$HBoxContainer/RichTextLabel.bbcode_text += "[center]\nPowered by Godot Engine\nFoxy Adventure - Copyright 2020 - "\
	+ str(OS.get_date().year) + " - New DEV\nGodot Engine - Copyright 2020 - " +\
	str(OS.get_date().year) + " - Godot Engine Contributors\n\nGekon. We'll never forget You!!!\n"+f.get_as_text()+"[/center]"#SilnyGekon
	$AnimationPlayer.play("credits")

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://Scenes/Menu.tscn")
