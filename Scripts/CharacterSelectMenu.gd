extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var new_chrs = Globals.new_characters
#var discord_rpc = DISCORD_RPC.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	for character in new_chrs:
		$ItemList.add_item(str(character))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func after_selecting_player():
	BackgroundLoad.load_scene(str(Globals.world))

func _on_Shadow_pressed():
	Globals.character_path = "res://Scenes/Characters/Shadow.tscn"
	Globals.selected_character = preload("res://Scenes/Characters/Shadow.tscn").instance()
	after_selecting_player()

func _on_Sonic_pressed():
	Globals.character_path = "res://Scenes/Characters/Sonic.tscn"
	Globals.selected_character = preload("res://Scenes/Characters/Sonic.tscn").instance()
	after_selecting_player()


func _on_New_pressed():
	Globals.character_path = "res://Scenes/Characters/NewTheFox.tscn"
	Globals.selected_character = preload("res://Scenes/Characters/NewTheFox.tscn").instance()
	after_selecting_player()


func _on_ItemList_item_selected(index):
	var item_name = $ItemList.get_item_text(index)
#	discord_rpc.set_details('Playing as ' + str(item_name))
	Globals.character_path = "res://Scenes/Characters/" + str(item_name) + ".tscn"
	Globals.selected_character = load("res://Scenes/Characters/" + str(item_name) + ".tscn").instance()
	after_selecting_player()
