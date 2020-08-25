extends AnimationPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func show():
	get_node("../").show()
func hide():
	get_node("../").hide()
