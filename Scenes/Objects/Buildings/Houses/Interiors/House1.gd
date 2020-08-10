extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var root = $YSort
# Called when the node enters the scene tree for the first time.
var character = Globals.selected_character
# Called when the node enters the scene tree for the first time.
func _ready():
	root.add_child(character)
	character.set_owner(root)
	character.set_position($start_position.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_exithouse_body_entered(body):
	if body.name == 'Sonic' or body.name == 'Shadow' or body.name == 'NewTheFox':
		body.connect('house_dialog_accept_2', self, 'on_house_dialog_event')
		body.show_exit_house_dialog()
		get_tree().paused = true


func _on_exithouse_body_exited(body):
	pass # Replace with function body.
func on_house_dialog_event(accepted:bool):
	if accepted:
		get_tree().paused = false
		get_tree().change_scene(str(Globals.world))
	else:
		get_tree().paused = false


func _on_Home1_tree_exiting():
	root.remove_child(character)
