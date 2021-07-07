extends Panel


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
signal new_tile_selected
signal rotate_tiles_left
signal rotate_tiles_right
signal erase_tiles_toggle
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VScrollBar.max_value = $Container.rect_size.y - $VScrollBar.rect_size.y

func set_disabled(disable:bool):
	for i in $Container.get_children():
		get_node("Container/" + i.name).disabled = disable

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass



func tile_selected(extra_arg_0: String) -> void:
	emit_signal("new_tile_selected", extra_arg_0)



func rotate_tiles_in_panel(mode:int):
	var sprite
	for i in $Conatiner.get_children():
#		print("child found" + str(i))
		sprite = i.get_node("Sprite")
		if mode == 0 and sprite: #rotate left
			sprite.rotation_degrees -= 90
		elif mode == 1 and sprite:#rotate right
			sprite.rotation_degrees += 90


func flip_tiles_in_panel(mode:int, value:bool):
	var sprite
	for i in $Container.get_children():
#		print("child found" + str(i))
		sprite = i.get_node("Sprite")
		if mode == 0 and sprite: #flip x
			sprite.set_flip_v(value)
		elif mode == 1 and sprite:#flip y
			sprite.set_flip_h(value)

func _on_rotateleft_pressed() -> void:
	rotate_tiles_in_panel(0)
	emit_signal("rotate_tiles_left")


func _on_rotateright_pressed() -> void:
	rotate_tiles_in_panel(1)
	emit_signal("rotate_tiles_right")




func _on_flipx_toggled(button_pressed: bool) -> void:
	flip_tiles_in_panel(0, button_pressed)
	Globals.flip_tiles_x = button_pressed

func _on_flipy_toggled(button_pressed: bool) -> void:
	flip_tiles_in_panel(1, button_pressed)
	Globals.flip_tiles_y = button_pressed


func _on_clear_toggled(button_pressed: bool) -> void:
	Globals.erase_tiles = button_pressed


func _on_VScrollBar_value_changed(value: float) -> void:
	$Container.set_position(Vector2(0, -(value)))
