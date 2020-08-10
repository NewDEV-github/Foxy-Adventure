extends Node

signal on_item_selected(item_stats);

onready var itemStats = get_parent().get_node("BackgroundContainer/ItemStats");
onready var inventory = get_parent().get_node("Inventory");

func _on_SlotButton_pressed(extra_arg_0):
	var keys = inventory._get_keys();
	
	if keys.size() > extra_arg_0:
		var item = inventory._get_item(keys[extra_arg_0]);
		emit_signal("on_item_selected", item);
		inventory._remove_item(keys[extra_arg_0], 1);
	pass;

func _on_SlotButton_mouse_entered(extra_arg_0):
	var keys = inventory._get_keys();
	
	if keys.size() > extra_arg_0:
		var item = inventory._get_item(keys[extra_arg_0]);
		itemStats.text += "Name: "  + str(keys[extra_arg_0]) + "\n";
		itemStats.text += "Type: " + str(item._get_stat("type")).capitalize() + "\n";
		itemStats.text += "Heal: "  + str(item._get_stat("heal")) + "\n";
		itemStats.text += "Damage: "  + str(item._get_stat("damage")) + "\n";
		itemStats.text += "Durability: "  + str(item._get_stat("durability")) + "\n";
		itemStats.text += "Quantity left: x" + str(inventory._get_item_count(keys[extra_arg_0])) + "\n";
	pass;

func _on_SlotButton_mouse_exited():
	itemStats.text = "";
	pass;
