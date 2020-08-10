extends Node

export(int) var INVENTORY_SIZE = 25;

var inventory = {};
onready var item = preload("res://Item/Item.tscn");

func _insert_item(item):
	if inventory.keys().size() < INVENTORY_SIZE:
		if inventory.has(item._get_name()):
			var _item_list = inventory[item._get_name()];
			_item_list.push_front(item);
		else:
			var _item_list = [];
			_item_list.push_front(item);
			inventory[item._get_name()] = _item_list;
	pass;

func _remove_item(item, quantity):
	if inventory.has(item):
		var _item = inventory[item];
		for i in range(quantity):
			_item.pop_front();
		if inventory[item].size() <= 0:
			inventory.erase(item);
	else:
		print("item not found");
	pass;

func _get_keys():
	return inventory.keys();
	pass;

func _get_item_count(key):
	if inventory.has(key):
		var _item_list = inventory[key];
		return _item_list.size();
	else:
		return 0;
	pass;

func _get_item(key):
	if inventory.has(key):
		return inventory[key][0];
	else:
		return 0;
	pass;

func _get_item_path(key):
	if inventory.has(key):
		var _item = inventory[key];
		return _item[0]._get_stat("path");
	else:
		return 0;

func _save_inventory_data():
	var save_inventory = File.new();
	
	save_inventory.open("res://invetorysave.json", File.WRITE);
	
	var json_data = {"Inventory Size":inventory._get_keys().size()};
	
	var inventory_keys = inventory._get_keys();
	
	for i in inventory_keys.size():
		var item = {"name": inventory_keys[i], "quantity": inventory._get_item_count(inventory_keys[i]), "path" : inventory._get_item_path(inventory_keys[i])}
		json_data[i] = item;			
	
	save_inventory.store_line(to_json(json_data));
		
	save_inventory.close();
	pass;

func _read_inventory_data():
	var inventory_save = File.new();
	if not inventory_save.file_exists("res://invetorysave.json"):
		print("file does not exists");
		return;
		
	inventory_save.open("res://invetorysave.json", File.READ)
	
	var current_line =  parse_json(inventory_save.get_line());
	
	var pos = 0;
	
	for i in range(current_line["Inventory Size"]):
		var _item = item.instance();
		for i in range(current_line[str(pos)]["quantity"]):
			_item._read_json_data(current_line[str(pos)]["path"][3], current_line[str(pos)]["path"][0], current_line[str(pos)]["path"][2], current_line[str(pos)]["path"][1]);
			inventory._insert_item(_item);
		pos+= 1;
	inventory_save.close();
	pass;