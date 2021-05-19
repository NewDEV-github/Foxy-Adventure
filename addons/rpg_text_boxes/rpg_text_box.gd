tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("RPGLabel", "RichTextLabel", preload("rpg_label.gd"), preload("rtb_icon.png"))


func _exit_tree():
	remove_custom_type("RPGLabel")
