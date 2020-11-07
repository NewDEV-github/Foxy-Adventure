# TilePainter
# Written by: First

extends Node2D

#class_name optional

"""
	Enter desc here.
"""

#-------------------------------------------------
#      Classes
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Constants
#-------------------------------------------------

const EYEDROP_MODIFIER_KEY = KEY_ALT
const UNDO_PAINT_TILE_ACTION_NAME = "Paint Tilemap"

#-------------------------------------------------
#      Properties
#-------------------------------------------------

onready var tilemap_preview = $TileMapPreview

var left_mouse_down : bool = false
var right_mouse_down : bool = false
var was_eyedrop_modifier_key_pressed : bool = false

var follow_mouse_pointer : bool setget set_follow_mouse_pointer
var tilemap : TileMap setget set_tilemap
var current_tile_id : int setget set_current_tile_id 

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _process(delta: float) -> void:
	if follow_mouse_pointer:
		global_position = get_global_mouse_position()
		
		#Snap position to the tilemap (if possible)
		if tilemap != null:
			position -= (tilemap.cell_size * 0.5)
			position = position.snapped(tilemap.cell_size)

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func process_input(event : InputEvent):
	#Set mouse being pressed or not
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			left_mouse_down = event.is_pressed()
			
			if event.is_pressed():
				_register_undo_start()
			else:
				_register_undo_end()
		if event.button_index == BUTTON_RIGHT:
			right_mouse_down = event.is_pressed()
			
			if event.is_pressed():
				_register_undo_start()
			else:
				_register_undo_end()
	
	if left_mouse_down:
		if Input.is_key_pressed(EYEDROP_MODIFIER_KEY):
			#Eyedropper
			eyedrop()
		else:
			#Set tile by current tile id
			set_tile(current_tile_id)
	if right_mouse_down: #Remove
		set_tile(-1)

#Set tile to a tilemap.
#If nodepath to tilemap is not specified, nothing will happen.
func set_tile(tile_id : int):
	if tilemap == null:
		return
	
	var cell_position = tilemap.world_to_map(self.get_global_position())
	var cell_tile_id_set = tile_id
	var cell_tile_id_undo = tilemap.get_cellv(cell_position)
	
	if cell_tile_id_set == cell_tile_id_undo:
		return
	
	LevelUndo.get_undo_redo().add_do_method(tilemap, "set_cellv", cell_position, cell_tile_id_set)
	LevelUndo.get_undo_redo().add_undo_method(tilemap, "set_cellv", cell_position, cell_tile_id_undo)
	tilemap.set_cellv(cell_position, cell_tile_id_set)
	
	UnsaveChanges.set_activated()

#Pick and update current tile from current mouse position.
func eyedrop():
	current_tile_id = tilemap.get_cellv(tilemap.world_to_map(self.get_global_position()))
	_update_tilemap_preview()

#-------------------------------------------------
#      Connections
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _update_tilemap_preview():
	if tilemap == null:
		return
	
	tilemap_preview.tile_set = tilemap.tile_set
	tilemap_preview.set_cellv(Vector2(0, 0), current_tile_id)
	tilemap_preview.cell_size = tilemap.cell_size

func _register_undo_start():
	was_eyedrop_modifier_key_pressed = Input.is_key_pressed(EYEDROP_MODIFIER_KEY)
	if was_eyedrop_modifier_key_pressed:
		return
	
	LevelUndo.get_undo_redo().create_action(UNDO_PAINT_TILE_ACTION_NAME)

func _register_undo_end():
	if was_eyedrop_modifier_key_pressed:
		return
	
	LevelUndo.get_undo_redo().commit_action()

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_follow_mouse_pointer(val):
	follow_mouse_pointer = val
	set_process(val)

func set_tilemap(val):
	tilemap = val
	_update_tilemap_preview()

func set_current_tile_id(val):
	current_tile_id = val
	_update_tilemap_preview()
