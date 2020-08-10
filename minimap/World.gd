extends Node2D

func _ready():
	var map_limits = $TileMap.get_used_rect()
	$Player/Camera2D.limit_left = map_limits.position.x * $TileMap.cell_size.x
	$Player/Camera2D.limit_top = map_limits.position.y * $TileMap.cell_size.y
	$Player/Camera2D.limit_right = map_limits.end.x * $TileMap.cell_size.x
	$Player/Camera2D.limit_bottom = map_limits.end.y * $TileMap.cell_size.y
	
	for object in get_tree().get_nodes_in_group("minimap_objects"):
		object.connect("removed", $CanvasLayer/MiniMap, "_on_object_removed")