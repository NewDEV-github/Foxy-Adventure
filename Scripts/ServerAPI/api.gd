extends HTTPRequest

# Declare member variables here. Examples:
signal scores_parsed
signal recived_log_id
var dir = Directory.new()
var file = File.new()

# Called when the node enters the scene tree for the first time.
var current_user_score = {}
signal scoredatarecived
var temp_score = -1 #we cannot get minus scores in the game so if this is -1 means, score was not given to the game by api
var _tmp_uid
var tmp_current_scene = ""
func _ready():
	var t = {'game': 'FoxyAdventure'}
	var params = JSON.print(t)
	$scores_getter.request("https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/leaderboard/get-scores", ["Content-Type: application/json"], false, HTTPClient.METHOD_POST, params)
func update_score(uid, score, upload=false):
	_tmp_uid = uid
#	$scores_getter.connect("request_completed", self, "get_scores")
#	var t = {'game': 'FoxyAdventure'}
#	var params = JSON.print(t)
#	$scores_getter.request("https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/leaderboard/get-scores", ["Content-Type: application/json"], false, HTTPClient.METHOD_POST, params)
#	yield(self, "scores_parsed")
	while not current_user_score.size() == 0:
		if temp_score == -1:
			temp_score = int(current_user_score[uid])
			temp_score += 1
			temp_score += score
		else:
			temp_score += score
		if upload == true:
			_upload_score()
func _upload_score():
	var t = {'userid': _tmp_uid, 'score': temp_score}
	var params = JSON.print(t)
	print("Posting new score")
	$scores_uploader.request("https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/leaderboard/new-score", ["Content-Type: application/json"], false, HTTPClient.METHOD_POST, params)
	yield($scores_uploader, "request_completed")
	t = {}
var tmp_log_id
func send_debug_log_to_database():
	var log_id
	var url = "https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/logs/send-log"
	var params = {'game': 'FoxyAdventure'}
	dir.open("user://logs/")
	dir.list_dir_begin()
	var file_name = dir.get_next()
	var av = ["engine_log.txt", ".", ".."]
	while av.has(file_name.get_file()):
		file_name = dir.get_next()
	print("user://logs/" + file_name.get_file())
	file.open("user://logs/" + file_name.get_file(), File.READ)
	params['log_text'] = file.get_as_text()
#	print("REQUEST PARAMS: " + str(params))
	var query = JSON.print(params)
	$logger.request(url, ["Content-Type: application/json"], false, HTTPClient.METHOD_POST, query)
	yield($logger, "request_completed")


func _on_logger_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	tmp_log_id = json.result
	emit_signal("recived_log_id")


func _on_scores_getter_request_completed(result, response_code, headers, body):
	var res = JSON.parse(body.get_string_from_utf8())
	current_user_score = res.result
	print(current_user_score)
	emit_signal("scores_parsed")
