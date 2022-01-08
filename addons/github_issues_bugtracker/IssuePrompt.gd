extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _tags = []
var _token = ""
# Called when the node enters the scene tree for the first time.
func _save_new_token(t:String):
	var f = File.new()
	f.open_encrypted_with_pass("res://gho_token", File.WRITE, "hcksU1jI")
	f.store_line(t)
	f.close()
func _ready():
	var f = File.new()
	f.open_encrypted_with_pass("res://gho_token", File.READ, "hcksU1jI")
	_token = f.get_line()
	f.close()
	_get_labels()


func _get_labels():
	$"../LabelsRequest".request('https://api.github.com/repos/%s/%s/labels' % ['NewDEV-github', "Foxy-Adventure"])

func _on_LabelsRequest_request_completed(result, response_code, headers, body):
	var labels_list = Array(JSON.parse(body.get_string_from_utf8()).result)
	for i in labels_list:
		print(i)
		_add_label(i["name"])

func _add_label(name_:String):
	var l = preload("res://addons/github_issues_bugtracker/label_base.tscn").instance()
	l.configure(name_)
	l.connect("l_toggled", self, "_label_toggled")
	$GridContainer.add_child(l)
func _label_toggled(_name:String, pressed:bool):
	if pressed:
		print("Checked label: "+ _name)
		_add_tag(_name)
	else:
		print("Unchecked label: "+ _name)
		_remove_tag(_name)
	print(_tags)

func _add_tag(t_name):
	_tags.append(t_name)

func _remove_tag(t_name):
	_tags.remove(_tags.find(t_name))
var issue_sender = preload("res://addons/github_issues_bugtracker/issues_api.py").new()
func send_issue():
	var _tags_str = str(_tags)
	_tags_str.erase(_tags_str.length() -1, 1) #remove ']'
	_tags_str.erase(0, 1) # remove '['
	print(_tags_str)
	issue_sender.make_github_issue($Tiitle.text, $Body.text, _tags_str, _token)
func _on_Send_pressed():
	send_issue()
	hide()
	


func _on_IssuePrompt_popup_hide():
	get_node("../").hide()
