extends Sprite
var minimap_icon = "mob"
export var lamp_turned_on:bool = true setget set_lamp_turned_on, get_lamp_turned_on
export var light_size:float = 1 setget set_light_size, get_light_size
export var light_energy:float = 1 setget set_light_energy, get_light_energy
export var shadow_enabled:bool = true setget set_shadow_enabled, get_shadow_enabled
func set_lamp_turned_on(new_value):
	lamp_turned_on = new_value
	$Lamp_1/Light2D.enabled = new_value
func set_light_size(new_light_size):
	light_size = new_light_size
	$Lamp_1/Light2D.texture_scale = new_light_size
func set_light_energy(new_value):
	light_energy = new_value
	$Lamp_1/Light2D.energy = new_value
func set_shadow_enabled(new_value):
	shadow_enabled = new_value
	$Lamp_1/Light2D.shadow_enabled = new_value
func get_lamp_turned_on():
	return lamp_turned_on
func get_light_size():
	return light_size
func get_light_energy():
	return light_energy
func get_shadow_enabled():
	return shadow_enabled
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	$Lamp_1/Light2D.enabled = lamp_turned_on
	$Lamp_1/Light2D.visible = lamp_turned_on
	$Lamp_1/Light2D.texture_scale = light_size
	$Lamp_1/Light2D.energy = light_energy
	$Lamp_1/Light2D.shadow_enabled = shadow_enabled


func _on_Area2D_body_entered(body):
	if body.name == 'Sonic' or body.name == 'Shadow' or body.name == 'NewTheFox':
		modulate = Color(1, 1, 1, Globals.object_transparency)


func _on_Area2D_body_exited(body):
	if body.name == 'Sonic' or body.name == 'Shadow' or body.name == 'NewTheFox':
		modulate = Color(1, 1, 1, 1)
