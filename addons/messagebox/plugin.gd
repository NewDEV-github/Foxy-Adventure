tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("MessageBox", "RichTextLabel", preload("message_box.gd"), preload("icon.png"))


func _exit_tree():
	remove_custom_type("MessageBox")
