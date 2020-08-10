extends Node2D
var start_position_nodes = {
	'house1': 'YSort/house1_position',
	'house2': 'YSort/house2_position',
	'house3': 'YSort/house3_position',
	'house4': 'YSort/house4_position',
	'house5': 'YSort/house5_position',
	'house6': 'YSort/house6_position',
	'house7': 'YSort/house7_position',
}

# Declare member variables here. Examples:
# var a = 2
onready var root = $YSort
var character = Globals.selected_character
# Called when the node enters the scene tree for the first time.
func _ready():
	
	Fmod.load_file_as_sound('res://Audio/BGS/001-Wind01.ogg')
	Globals.fmod_sound_sfx_instance = Fmod.create_sound_instance('res://Audio/BGS/001-Wind01.ogg')
	Fmod.set_sound_volume(Globals.fmod_sound_sfx_instance, -10)
	Fmod.play_sound(Globals.fmod_sound_sfx_instance)
#	Fmod.load_bank('res://Audio/banks/', Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
	root.add_child(character)
	character.set_owner(root)
	
#	character.set_name('Character')
	if Globals.coming_from_house == '' or Globals.coming_from_house == null:
		character.set_position($start_position.position)
		$AnimationPlayer.play("end_transition")
	else:
		$CanvasLayer/Control.hide()
		var house_name = str(Globals.coming_from_house)
		var position_node = start_position_nodes.get(str(house_name))
		character.set_position(get_node(position_node).position)
#	$CanvasLayer/MiniMap.player = get_node('YSort/' + str(character.name))
#	else:
#		print(str(Globals.last_world_position))
#		character.set_position(Globals.last_world_position)



func _on_Node2D_tree_exiting():
	character.save_last_world_position()
	root.remove_child(character)
	character = null
	Fmod.stop_sound(Globals.fmod_sound_sfx_instance)
