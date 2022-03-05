extends Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/HSlider.value = 50
	$CanvasLayer/VSlider.value = 50
	$"CanvasLayer/TileSelector".connect("new_tile_selected", self, "on_new_tile_selected")
#	$CanvasLayer/TileSelector.connect("new_tile_selected", self, "on_new_tile_selected")

func on_new_tile_selected(tile_name):
	print("New tile: " + tile_name)
	Globals.current_tile_name = tile_name




func _on_navbar_mouse_entered():
	EditorGlobals.can_place_tiles = false


func _on_TileSelector_mouse_entered():
	EditorGlobals.can_place_tiles = false


func _on_navbar_mouse_exited():
	EditorGlobals.can_place_tiles = true


func _on_TileSelector_mouse_exited():
	EditorGlobals.can_place_tiles = true


func _on_ProjectSelect_mouse_entered():
	EditorGlobals.can_place_tiles = false


func _on_ProjectSelect_mouse_exited():
	EditorGlobals.can_place_tiles = true


func _on_VSlider_value_changed(value):
	$Node2D.position = Vector2($Node2D.position.x, -(value*10))


func _on_HSlider_value_changed(value):
	$Node2D.position = Vector2(-(value*10), $Node2D.position.y)


func _on_VSlider_mouse_entered():
	EditorGlobals.can_place_tiles = false


func _on_VSlider_mouse_exited():
	EditorGlobals.can_place_tiles = true


func _on_HSlider_mouse_exited():
	EditorGlobals.can_place_tiles = true


func _on_HSlider_mouse_entered():
	EditorGlobals.can_place_tiles = false
