extends LineEdit

var Http = load("res://Scenes/ServerAPI/http.tscn")

func _ready():
	var http = get_node("../../../HTTPRequest")
	http.request("https://api-sonadowrpg.herokuapp.com/ips.json")
	var instance = Http.instance()
	self.add_child(instance)
	get_node("../LineEdit/HTTPRequest").get_url("ips.json", self)

func handle_results(results):
	for server in results:
		self.text = server
