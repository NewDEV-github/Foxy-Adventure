extends HTTPRequest
var prefix = "nd!"
var token = null
var client : WebSocketClient
var heartbeat_interval : float
var last_sequence : float
var session_id : String
var heartbeat_ack_received := true
var invalid_session_is_resumable : bool

func send_feedback_msg(text:String, resp_email:String, thanks_popup:bool = true):
	if text != "":
		var new_text = "<@&763764844381864007>\n\n\n**Message: **\n" + text + "\n\n\n**Response Email: **" + resp_email + "\n\n**OS:** " + str(OS.get_name()) + "\n**Godot version:** " + str(Engine.get_version_info()) + "\n**Debug build:** " + str(OS.is_debug_build())
		var myEmbed = {
			"author": {
				"name": "Foxy Adventure"
			},
			"title": "New feedback is here!",
			"description": new_text,
			"color": "4259584"
			}
		var headers := ["Content-Type: application/json"]
		var params = {
			"username": "Feedback",
			"embeds": [myEmbed],
		}
		var query = JSON.print(params)
#		var channel_id = "763763543073226822/763802916032872488" #feedback channel
		request(Marshalls.base64_to_utf8("aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvNzc5MDg4MzI4MjI1NTg3MjcxL3dJVDkwcWFPVzJMQTBQcnJRWmlTYmdsRVB6eXhvTlNPak5Eb2V5Q3BUS0loc3lPTkM5ZzVEeUVWVFdMZWRQZ3VERVdf"), headers, true, HTTPClient.METHOD_POST, query)
		yield(self, "request_completed")
		if thanks_popup:
			$Expand.hide()
			$DscDMCreator.hide()
			$FeedBack.hide()
			$ThanksDialog.popup_centered()
		if $DscDMCreator/VBoxContainer/error_log.pressed:
			send_err_log_msg()
func _on_Send_pressed():
#	var fd = 
	send_feedback_msg(str($DscDMCreator/VBoxContainer/text/text.text),str($DscDMCreator/VBoxContainer/email/email.text), true)
#	if fd == "ok":
#		pass
#	else:
#		$DscDMCreator/VBoxContainer/error_label.text = "ERROR: " + str(fd)
#

func send_feedback():
	$FeedBack.popup_centered()


func _on_DSCdm_pressed():
	$DscDMCreator.popup_centered()


func _on_ExpandDSCMSG_pressed():
	$Expand/TextEdit.text = $DscDMCreator/VBoxContainer/text/text.text
	$Expand.popup_centered()


func _on_TextEdit_text_changed():
	$DscDMCreator/VBoxContainer/text/text.text = $Expand/TextEdit.text


func _on_DSCServer_pressed():
	OS.shell_open("https://discord.gg/MJmygUC")


func _on_Website_pressed():
	OS.shell_open("https://www.new-dev.ml")


func _on_Facebook_pressed():
	pass # Replace with function body.

func send_err_log_msg():
	var f = File.new()
	f.open("user://logs/engine_log.txt", File.READ)
	var new_text = "<@&763764844381864007> \n\n" + str(f.get_as_text()) + "\n\n**OS:** " + str(OS.get_name()) + "\n**Godot version:** " + str(Engine.get_version_info()) + "\n**Debug build:** " + str(OS.is_debug_build())
	var headers := ["Content-Type: application/json"]
	var myEmbed = {
		"author": {
			"name": "Foxy Adventure"
		},
		"title": "New error catched up!",
		"description": new_text,
		"color": "16711680"
		}
#	var headers := ["Content-Type: application/json"]
	var params = {
		"username": "In-game errors",
		"embeds": [myEmbed],
	}
	var msg = {"content": "", "embed": {"title": "New error catched up!", "description": new_text}}
	var query = JSON.print(params)
#	var channel_id = "773150027106484234"
	f.close()
	request(Marshalls.base64_to_utf8("aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvNzc5MDg4MzE1Njc1NTc0MzEzL2M2aVhRR3hOUU5jYzZjX293R09odjFmQWNFM0JRRE4zUnlobDVxV09XVV9sMmtfWlNXQy1McGxmVDctWTF1RDF4dUxw"), headers, true, HTTPClient.METHOD_POST, query)
