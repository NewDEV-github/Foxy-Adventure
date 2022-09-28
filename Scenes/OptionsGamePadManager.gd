extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func refresh():
	for i in get_children():
		remove_child(i)
	for i in Globals.game_pad_clients:
		var n = load("res://Scenes/gamepadbtn.tscn").instance()
		n.initialize(i)
		add_child(n)



func _on_Button_pressed():
	refresh()
