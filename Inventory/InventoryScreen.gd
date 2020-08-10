extends Node2D

onready var inventory = $Inventory; #The node with inventory.gd script
onready var slot_buttons = [
	get_node("SlotsContainer/Slot1Button"),
	get_node("SlotsContainer/Slot2Button"),
	get_node("SlotsContainer/Slot3Button"),
	get_node("SlotsContainer/Slot4Button"),
	get_node("SlotsContainer/Slot5Button"),
	get_node("SlotsContainer/Slot6Button"),
	get_node("SlotsContainer/Slot7Button"),
	get_node("SlotsContainer/Slot8Button"),
	get_node("SlotsContainer/Slot9Button"),
	get_node("SlotsContainer/Slot10Button"),
	get_node("SlotsContainer/Slot11Button"),
	get_node("SlotsContainer/Slot12Button"),
	get_node("SlotsContainer/Slot13Button"),
	get_node("SlotsContainer/Slot14Button"),
	get_node("SlotsContainer/Slot15Button"),
	get_node("SlotsContainer/Slot16Button"),
	get_node("SlotsContainer/Slot17Button"),
	get_node("SlotsContainer/Slot18Button"),
	get_node("SlotsContainer/Slot19Button"),
	get_node("SlotsContainer/Slot20Button"),
	get_node("SlotsContainer/Slot21Button"),
	get_node("SlotsContainer/Slot22Button"),
	get_node("SlotsContainer/Slot23Button"),
	get_node("SlotsContainer/Slot24Button"),
	get_node("SlotsContainer/Slot25Button")
] #Slots buttons

func _process(delta):
	_get_inventory_items();
	pass;

func _get_inventory_items(): #Get all inventory keys and check if the slot should have the text of the item
	var keys = inventory._get_keys();
	
	for i in range(slot_buttons.size()): #For all slot button(you can add more if you)
		if  i < keys.size(): 
			slot_buttons[i].text = keys[i];
		else: 
			slot_buttons[i].disabled = true;
			slot_buttons[i].text = "";
	pass;
