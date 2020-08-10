extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == 'Sonic' or body.name == 'Shadow' or body.name == 'NewTheFox':
		$Sprite.self_modulate = Color(1, 1, 1, Globals.object_transparency)


func _on_Area2D_body_exited(body):
	if body.name == 'Sonic' or body.name == 'Shadow' or body.name == 'NewTheFox':
		$Sprite.self_modulate = Color(1, 1, 1, 1)
