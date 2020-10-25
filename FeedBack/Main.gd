extends HTTPRequest
var token = null# Make sure to actually replace this with your token!
var client : WebSocketClient
var heartbeat_interval : float
var last_sequence : float
var session_id : String
var heartbeat_ack_received := true
var invalid_session_is_resumable : bool

func _ready() -> void:
	$FeedBack/TabContainer/Discord/options/DM/DSCdm.disabled = false
	$tokenrequest.request("https://www.new-dev.ml/api/feedback-bot-token/")
	yield($tokenrequest,"request_completed")
	randomize()
	client = WebSocketClient.new()
	client.connect_to_url("wss://gateway.discord.gg/?v=6&encoding=json")
	client.connect("connection_error", self, "wss_dm_error")
	client.connect("connection_established", self, "_connection_established")
	client.connect("connection_closed", self, "_connection_closed")
	client.connect("server_close_request", self, "_server_close_request")
	client.connect("data_received", self, "_data_received")

func wss_dm_error():
	$FeedBack/TabContainer/Discord/options/DM/DSCdm.disabled = true
func _process(_delta : float) -> void:
	if not token == null:
	# Check if the client is not disconnected, there's no point to poll it if it is
		if client.get_connection_status() != NetworkedMultiplayerPeer.CONNECTION_DISCONNECTED:
			client.poll()
		else:
		# If it is disconnected, try to resume
			var err = client.connect_to_url("wss://gateway.discord.gg/?v=6&encoding=json")
			if !err:
				set_process(false)

func _connection_established(protocol : String) -> void:
	$FeedBack/TabContainer/Discord/options/DM/DSCdm.disabled = false
	print("We are connected! Protocol: %s" % protocol)

func _connection_closed(was_clean_close : bool) -> void:
	print("We disconnected. Clean close: %s" % was_clean_close)
	wss_dm_error()
func _server_close_request(code : int, reason : String) -> void:
	print("The server requested a clean close. Code: %s, reason: %s" % [code, reason])

func _data_received() -> void:
	var packet := client.get_peer(1).get_packet()
	var data := packet.get_string_from_utf8()
	var json_parsed := JSON.parse(data)
	var dict : Dictionary = json_parsed.result
	var op = str(dict["op"]) # Convert it to string for easier checking
	print(op)
	match op:
		"0": # Opcode 0 Dispatch (Events)
			handle_events(dict)
		"9": # Opcode 9 Invalid Session
			invalid_session_is_resumable = dict["d"]
			$InvalidSessionTimer.one_shot = true
			$InvalidSessionTimer.wait_time = rand_range(1, 5)
			$InvalidSessionTimer.start()
		"10": # Opcode 10 Hello
			# Set our timer
			heartbeat_interval = dict["d"]["heartbeat_interval"] / 1000
			$HeartbeatTimer.wait_time = heartbeat_interval
			$HeartbeatTimer.start()

			var d := {}
			if !session_id:
				# Send Opcode 2 Identify to the Gateway
				d = {
					"op" : 2,
					"d" : { "token" : token, "properties" : {}}
				}
			else:
				# Send Opcode 6 Resume to the Gateway
				d = {
					"op" : 6,
					"d" : { "token" : token, "session_id" : session_id, "seq" : last_sequence}
				}
			send_dictionary_as_packet(d)
		"11": # Opcode 11 Heartbeat ACK
			heartbeat_ack_received = true
			print("We've received a Heartbeat ACK from the gateway.")


func _on_HeartbeatTimer_timeout() -> void: # Send Opcode 1 Heartbeat payloads every heartbeat_interval
	if !heartbeat_ack_received:
		# We haven't received a Heartbeat ACK back, so we'll disconnect
		client.disconnect_from_host(1002)
		return
	var d := {"op" : 1, "d" : last_sequence}
	send_dictionary_as_packet(d)
	heartbeat_ack_received = false
	print("We've send a Heartbeat to the gateway.")

func send_dictionary_as_packet(d : Dictionary) -> void:
	var query = to_json(d)
	client.get_peer(1).put_packet(query.to_utf8())

func handle_events(dict : Dictionary) -> void:
	last_sequence = dict["s"]
	var event_name : String = dict["t"]
	print(event_name)
	match event_name:
		"READY":
			session_id = dict["d"]["session_id"]
		"GUILD_MEMBER_ADD":
			var guild_id = dict["d"]["guild_id"]
			var headers := ["Authorization: Bot %s" % token]

			# Get all channels of the guild
			request("https://discordapp.com/api/guilds/%s/channels" % guild_id, headers)
			var data_received = yield(self, "request_completed") # await
			var channels = JSON.parse(data_received[3].get_string_from_utf8()).result
			var channel_id
			for channel in channels:
				# Find the first text channel and get its ID
				if str(channel["type"]) == "0":
					channel_id = channel["id"]
					break
			if channel_id: # If we found at least one text channel
				var username = dict["d"]["user"]["username"]
				var message_to_send := {"content" : "Welcome %s!" % username}
				var query := JSON.print(message_to_send)
				headers.append("Content-Type: application/json")
				request("https://discordapp.com/api/v6/channels/%s/messages" % channel_id, headers, true, HTTPClient.METHOD_POST, query)
		"MESSAGE_CREATE":
			var channel_id = dict["d"]["channel_id"]
			var message_content = dict["d"]["content"]

			var headers := ["Authorization: Bot %s" % token, "Content-Type: application/json"]
			var query : String

			if message_content.to_upper() == "ORAMA":
				var message_to_send := {"content" : "Interactive"}
				query = JSON.print(message_to_send)
			elif message_content.to_upper() == "WEBSITE":
				var message_to_send := {"content" : "http://oramagamestudios.com/"}
				query = JSON.print(message_to_send)
			elif message_content.to_upper() == "BLOG":
				var message_to_send := {"content" : "https://functionoverload590613498.wordpress.com"}
				query = JSON.print(message_to_send)
			elif message_content.to_upper() == "GITHUB":
				var message_to_send := {"content" : "test"}
				query = JSON.print(message_to_send)
			if query:
				print(str(channel_id))
				request("https://discordapp.com/api/v6/channels/%s/messages" % channel_id, headers, true, HTTPClient.METHOD_POST, query)

func _on_InvalidSessionTimer_timeout() -> void:
	var d := {}
	if invalid_session_is_resumable && session_id:
		# Send Opcode 6 Resume to the Gateway
		d = {
			"op" : 6,
			"d" : { "token" : token, "session_id" : session_id, "seq" : last_sequence}
		}
	else:
		# Send Opcode 2 Identify to the Gateway
		d = {
			"op" : 2,
			"d" : { "token" : token, "properties" : {} }
		}
	send_dictionary_as_packet(d)



func _on_Send_pressed():
	var new_text = "<test@&763764844381864007> \n**New Feedback sent**\n\n\n**Message: **\n" + str($DscDMCreator/VBoxContainer/text/text.text) + "\n\n\n**Response Email: **" + $DscDMCreator/VBoxContainer/email/email.text + "\n\n**OS:** " + str(OS.get_name()) + "\n**Godot version:** " + str(Engine.get_version_info()) + "\n**Debug build:** " + str(OS.is_debug_build())
	var headers := ["Authorization: Bot %s" % token, "Content-Type: application/json"]
	var msg = {"content": new_text}
	var query = JSON.print(msg)
	var channel_id = "763802916032872488" #feedback channel
	request("https://discordapp.com/api/v6/channels/%s/messages" % channel_id, headers, true, HTTPClient.METHOD_POST, query)
#	yield(self, "request_completed")
#	channel_id = "713381966195458098" #newtf
#	request("https://discordapp.com/api/v6/channels/%s/messages" % channel_id, headers, true, HTTPClient.METHOD_POST, query)
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


func _on_tokenrequest_request_completed(result, response_code, headers, body):
	if result == 2:
		ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_HTTPREQ_CANT_CONNECT)
	if result == 3:
		ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_HTTPREQ_CANT_RESOLVE)
	if result == 4:
		ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_HTTPREQ_CONNECTION_ERR)
	if result == 6:
		ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_HTTPREQ_NO_RESPONSE)
	if result == 9:
		ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_HTTPREQ_CANT_OPEN)
	if result == 10:
		ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_HTTPREQ_CANT_WRITE)
	if not result == 0:
		ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_DOWNLOADING_DATA)
		ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_MISSING_DATA_FILES)
		ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_INITIALIZING_GAME)
#		get_tree().quit()
	if result ==0:
		var json = JSON.parse(body.get_string_from_utf8())
		var json_result = json.result
		print(str(json_result))
		token = str(json_result)
