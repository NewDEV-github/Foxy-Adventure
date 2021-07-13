extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("achivement_done", self, "achivement_unlocked")
	

func achivement_unlocked(achivement_name:String):
	$VBoxContainer/Name.text = achivement_name
	$VBoxContainer/Description.text = Globals.achievements_desc[achivement_name]
	$AnimationPlayer.play("show_up")
