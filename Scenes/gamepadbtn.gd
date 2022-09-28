extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _id

# Called when the node enters the scene tree for the first time.
func initialize(id):
	_id = id
	$HBoxContainer/Label.text = str(_id)

func _on_Button_pressed():
	pass # Replace with function body.
