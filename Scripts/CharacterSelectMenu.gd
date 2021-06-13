extends Control
export (bool) var tooltip_enabled = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var new_chrs = Globals.new_characters
#var discord_rpc = DISCORD_RPC.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.arguments.has("locale"):
		print("Setting locale to: " + Globals.arguments["locale"])
		TranslationServer.set_locale(Globals.arguments["locale"])
	BackgroundLoad.get_node("bgload").play_start_transition = true
	var new_chrs = Globals.new_characters
	print(str(new_chrs))
	for character in new_chrs:
		$ItemList.add_item(str(character))
		var item_id = $ItemList.get_item_count() -1
		$ItemList.set_item_tooltip_enabled(item_id, tooltip_enabled)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func after_selecting_player():
#	Globals.save_level(0, Globals.current_save_name)
	BackgroundLoad.get_node("bgload").load_scene("res://Scenes/Stages/poziom_1.tscn")
#	BackgroundLoad

func _on_ItemList_item_selected(index):
	var item_name = $ItemList.get_item_text(index)
	
#	discord_rpc.set_details('Playing as ' + str(item_name))
	if OS.get_name() == "Android":
		Globals.character_path = "res://Scenes/Characters/" + str(item_name) + "_android.tscn"
		Globals.selected_character = load("res://Scenes/Characters/" + str(item_name) + "_android.tscn").instance()
	else:
		Globals.character_path = "res://Scenes/Characters/" + str(item_name) + ".tscn"
		Globals.selected_character = load("res://Scenes/Characters/" + str(item_name) + ".tscn").instance()
#	if Globals.selected_character == null:
#		ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_LOADING_DATA)
#		ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_GAME_DATA)
	after_selecting_player()


func _on_Cancel_pressed():
	get_parent().hide()
