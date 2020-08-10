extends Node2D

var id;
var item_name;
var type;
var heal;
var damage;
var durability;
var path;

func _read_json_data(index, region, rarity, _type):
	var items_file = File.new();
	if not items_file.file_exists("res://items.json"):
		print("file does not exists");
		return;
		
	items_file.open("res://items.json", File.READ)
	
	var data = {};
	
	data = parse_json(items_file.get_as_text());
	print(data);
	id = index;
	item_name = data[region][_type][rarity][str(index)]["name"];
	type = data[region][_type][rarity][str(index)]["type"];
	heal = data[region][_type][rarity][str(index)]["heal"];
	damage = data[region][_type][rarity][str(index)]["damage"];
	durability = data[region][_type][rarity][str(index)]["durability"];
	path = data[region][_type][rarity][str(index)]["path"];
	
	items_file.close();
	pass;

func _print_data():
	print("#################");
	print(id);
	print(item_name);
	print(type);
	print(heal);
	print(damage);
	print(durability);
	print(path);
	print("#################");
	pass;

func _get_id():
	return id;
	pass;

func _get_name():
	return item_name;
	pass;
	
func _get_stat(_stat):
	if _stat == "type":
		return type;
	elif _stat == "heal":
		return heal;
	elif _stat == "damage":
		return damage;
	elif _stat == "durability":
		return durability;
	elif _stat == "path":
		return path;
	pass;

func _set_durability(value):
	durability = value;
	pass;