extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tags = {
	"# ": '[b][font=res://assets/fonts/roboto_font_xl.tres]%s[/font][/b]',
	"## ": '[b][font=res://assets/fonts/roboto_font_l.tres]%s[/font][/b]',
	"### ": '[b][font=res://assets/fonts/roboto_font_m.tres]%s[/font][/b]',
	"#### ": '[b][font=res://assets/fonts/roboto_font_s.tres]%s[/font][/b]',
	"##### ": '[b][font=res://assets/fonts/roboto_font_xs.tres]%s[/font][/b]',
	"###### ": '[b][font=res://assets/fonts/roboto_font_xxs.tres]%s[/font][/b]',
	"* ": '• %s',
	"- ": '• %s',
	"<!--": "%s",
}
#
## Called when the node enters the scene tree for the first time.
func _ready():
	process_to_bbcode("# Header One\n## Header Two\n### Header 3\n#### Header 4\n##### Header 5\n###### Header 6\n* lol\n- lolz")


func process_to_bbcode(_text:String):
	var _lines = _text.split("\n")
	var new_text = ""
	for i in _lines:
		print("SCANNING: " + i)
		new_text += _parse_line(i)
	bbcode_text = new_text

func _parse_line(_text:String):
	var text_to_return = _text
	for i in tags:
		print(_text.begins_with(i))
		if _text.begins_with(i): #has one of tags
			if i == "<!--":
				text_to_return = ""
			else:
				var _nt = _text.trim_prefix(i)
				print("NT: " + _nt)
				text_to_return=str(str(tags[i]) % _nt)
		else:#none, go try other methods
			var regex = RegEx.new()
			var patterns = {
				"(http|ftp|https):\\/\\/([\\w_-]+(?:(?:\\.[\\w_-]+)+))([\\w.,@?^=%&:\\/~+#-]*[\\w@?^=%&\\/~+#-])": "url", #url address
				"(\\*+)(\\s*\\b)([^\\*]*)(\\b\\s*)(\\*+)": "bold"
			}
			for i2 in patterns:
				regex.compile(i2)
				var result = regex.search(_text)
				if result != null:
					print("Regex result is: " + result.get_string())
					if patterns[i2] == "url":
						text_to_return = _text.replace(result.get_string(), _parse_url(result.get_string()))
					elif patterns[i2] == "bold":
						text_to_return = _text.replace(result.get_string(), _parse_bold(result.get_string()))
	return text_to_return + "\n"


func _parse_url(url:String):
	var ret_text = url
	var splitted_url = Array(url.split('/'))
	if splitted_url.has('pull'): #pull request
		print("pull")
		var pull_number = splitted_url.back()
		ret_text = "[color=#58a6ff][url=%s]#%s[/url][/color]" % [url, pull_number]
	elif splitted_url.has('compare'): #compare
		print("compare")
		var comparision_t = splitted_url.back()
		ret_text = "[color=#58a6ff][url=%s]#%s[/url][/color]" % [url, comparision_t]
	return ret_text

func _parse_bold(t:String):
	var t1 = t.trim_prefix('**')
	var t2 = t1.trim_suffix('**')
	return "[b]" + t2 + "[/b]"
