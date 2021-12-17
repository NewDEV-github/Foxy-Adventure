extends ItemList

var mouse_select
var last_index

func _ready():  
	select_mode = ItemList.SELECT_SINGLE

func _input(event):
	# Check ItemList
	if InputEventMouse and mouse_select == true:
		var itm = get_item_at_position(get_local_mouse_position(),false)
		select(itm)
		# Using select() doesn't trigger item_selected
		_on_ItemList_item_selected(itm)

	pass

func _on_ItemList_mouse_entered():
	mouse_select = true

func _on_ItemList_mouse_exited():
	mouse_select = false
	unselect(get_selected_items()[0])

func _on_ItemList_item_selected(index):
	if not index == last_index:
		print(index)
		last_index = index
