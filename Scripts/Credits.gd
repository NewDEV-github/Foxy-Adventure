extends Control
# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property($spectrum, "linear_color", Color.red, Color.blue, 4, Tween.TRANS_LINEAR)
	$Tween.start()
#	Fmod.add_listener(0, self)
#	Fmod.play_music_sound_instance("res://assets/Audio/BGM/credits_gekagd.ogg", "Credits")
	var f = File.new()
	f.open("gekagd.txt", File.READ)
	$HBoxContainer/RichTextLabel.bbcode_text += "[center]\nPowered by Godot Engine\nFoxy Adventure - Copyright 2020 - "\
	+ str(OS.get_date().year) + " - New DEV\nGodot Engine - Copyright 2020 - " +\
	str(OS.get_date().year) + " - Godot Engine Contributors"#SilnyGekon
	$AnimationPlayer.play("credits")
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://Scenes/Menu.tscn")
func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://Scenes/Menu.tscn")

func _on_Control_tree_exiting():
#	Fmod.stop_sound(Fmod.music_instances["Credits"])
	pass


func _on_Tween_tween_completed(object, key):
	$Tween2.interpolate_property($spectrum, "linear_color", Color.blue, Color.red, 5, Tween.TRANS_LINEAR)
	$Tween2.start()


func _on_Tween2_tween_completed(object, key):
	$Tween.interpolate_property($spectrum, "linear_color", Color.red, Color.blue, 5, Tween.TRANS_LINEAR)
	$Tween.start()
