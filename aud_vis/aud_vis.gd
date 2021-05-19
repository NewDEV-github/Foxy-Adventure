tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("AudioVisualizer", "Node2D", preload("res://addons/aud_vis/visualizer.gd"), preload("res://addons/aud_vis/AudVis.png"))


func _exit_tree():
	remove_custom_type("AudioVisualizer")
