extends AnimatedSprite

var frame_count = [0, 1, 2, 3]
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	frame = frame_count[randi() % frame_count.size()]
	play("default")
