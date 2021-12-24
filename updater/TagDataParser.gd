extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func parse_text_from_dictionary(dict:Dictionary, bbcode:bool=true, avoid=[]) -> void:
	bbcode_text = ""
	text = ""
	if bbcode:
		bbcode_enabled = true
		bbcode_text = _parser(dict, bbcode, false, avoid)
	else:
		bbcode_enabled = false
		text = _parser(dict, bbcode, false, avoid)
func _parser(dict:Dictionary, bbcode:bool=true, add_tab:bool=false, avoid=[]):
	var ret_text = ""
	var keys = dict.keys()
	for i in keys:
		print(i)
		if not avoid.has(i):
			if typeof(dict[i]) == 4: #String
				var normal_key = i.capitalize()
				if bbcode:
					if add_tab:
						ret_text += "	[b]" + normal_key + ":[/b]\n	"+dict[i] + "\n\n"
					else:
						ret_text += "[b]" + normal_key + ":[/b]\n"+dict[i] + "\n\n"
				else:
					if add_tab:
						ret_text += "	" + normal_key + ":\n	"+dict[i] + "\n\n"
					else:
						ret_text += normal_key + ":\n"+dict[i] + "\n\n"
			elif typeof(dict[i]) == 18: #Dictionary
				var normal_key = i.capitalize()
				if bbcode:
					if add_tab:
						ret_text += "	[b]" +normal_key + ":[/b]\n	"+ _parser(dict[i], bbcode, true) + "\n\n"
					else:
						ret_text += "[b]" +normal_key + ":[/b]\n"+ _parser(dict[i], bbcode, true) + "\n\n"
				else:
					if add_tab:
						ret_text += "	" + normal_key + ":\n	"+ _parser(dict[i], bbcode, true) + "\n\n"
					else:
						ret_text += normal_key + ":\n"+ _parser(dict[i], bbcode, true) + "\n\n"
			elif typeof(dict[i]) == 19:#Array
				var normal_key = i.capitalize()
				if bbcode:
					if add_tab:
						ret_text += "	[b]" + normal_key + ":[/b]\n	"+ _parse_array(dict[i]) + "\n\n"
					else:
						ret_text += "[b]" + normal_key + ":[/b]\n"+_parse_array(dict[i]) + "\n\n"
				else:
					if add_tab:
						ret_text += "	" + normal_key + ":\n	"+_parse_array(dict[i]) + "\n\n"
					else:
						ret_text += normal_key + ":\n"+_parse_array(dict[i]) + "\n\n"
	return ret_text

func _parse_array(array:Array):
	var ret_text = ""
	for i in array:
		if i == array[-1]:
			if typeof(i) == 4:
				ret_text += i.capitalize()
			elif typeof(i) == 18:
				ret_text += _parser(i, true)
		else:
			if typeof(i) == 4:
				ret_text += i.capitalize() + ", "
			elif typeof(i) == 18:
				ret_text += _parser(i, true)
	return ret_text
