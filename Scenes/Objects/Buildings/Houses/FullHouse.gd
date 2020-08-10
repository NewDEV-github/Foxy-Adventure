extends Sprite
var minimap_icon = "alert"
export var house_name:String = '' setget set_house_name, get_house_name
var pos = self.get_position_in_parent()
export var house_interior:PackedScene setget set_house_interior, get_house_interior
func set_house_name(new_house_name):
	house_name = new_house_name
func get_house_name():
	return house_name
func set_house_interior(new_house_interior):
	house_interior = new_house_interior
func get_house_interior():
	return house_interior
func _on_Area2D_body_entered(body):
	pos = self.get_position_in_parent()
	Globals.last_world_position = $start_position.position
	if body.name == 'Sonic' or body.name == 'Shadow' or body.name == 'NewTheFox':
		Globals.coming_from_house = house_name
		body.connect('house_dialog_accept', self, 'on_house_dialog_event')
		body.show_enter_house_dialog()
		body.save_last_world_position()
		get_tree().paused = true

func on_house_dialog_event(accepted:bool):
	if accepted:
		get_tree().change_scene(str(house_interior.resource_path))
	else:
		pass


func _on_Area2D2_body_entered(body):
	if body.name == 'Sonic' or body.name == 'Shadow' or body.name == 'NewTheFox':
		$House.self_modulate = Color(1, 1, 1, Globals.object_transparency)


func _on_Area2D2_body_exited(body):
	if body.name == 'Sonic' or body.name == 'Shadow' or body.name == 'NewTheFox':
		$House.self_modulate = Color(1, 1, 1, 1)
