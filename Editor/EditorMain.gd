extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/TileSelector.connect("new_tile_selected", self, "on_new_tile_selected")

func on_new_tile_selected(tile_name):
	Globals.current_tile_name = tile_name


