extends Control
# Called when the node enters the scene tree for the first time.
func _ready():
	Fmod.add_listener(0, self)
	Fmod.play_music_sound_instance("res://assets/Audio/BGM/credits_gekagd.ogg", "Credits")
	var f = File.new()
	f.open("gekagd.txt", File.READ)
	$HBoxContainer/RichTextLabel.bbcode_text += "[center]\nPowered by Godot Engine\nFoxy Adventure - Copyright 2020 - "\
	+ str(OS.get_date().year) + " - New DEV\nGodot Engine - Copyright 2020 - " +\
	str(OS.get_date().year) + " - Godot Engine Contributors\n\nGekon, our team wants to say big 'Thank You' to You\nfor putting a lot of non-obligatory job into the game.[/center]"#SilnyGekon
	$AnimationPlayer.play("credits")
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://Scenes/Menu.tscn")
func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://Scenes/Menu.tscn")


func _on_Control_tree_exiting():
	Fmod.stop_sound(Fmod.music_instances["Credits"])
