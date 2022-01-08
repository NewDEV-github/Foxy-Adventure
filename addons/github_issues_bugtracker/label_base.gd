extends CheckBox


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

signal l_toggled(label_name, pressed)
func configure(name_label:String):
	text = name_label


func _on_CheckBox_toggled(button_pressed):
	emit_signal("l_toggled", text, button_pressed)
