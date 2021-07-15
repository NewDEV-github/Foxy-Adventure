extends HTTPRequest


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
var current_user_score = {}
signal scoredatarecived
var temp_score = -1 #we cannot get minus scores in the game so if this is -1 means, score was not given to the game by api
var _tmp_uid
var tmp_current_scene = ""
var t_score
#func _ready():
#	update_score("PVcDnhjJkrMYXMytyuT5ZgEboir1", 50)
func force_upload():
	if current_user_score != {}:
		_upload_score()
func update_score(uid, score):
	_tmp_uid = uid
	t_score = score
	var t = {'game': 'Foxy Adventure'}
	var params = JSON.print(t)
	$scores_getter.request("https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/leaderboard/get-scores", ["Content-Type: application/json"], false, HTTPClient.METHOD_POST, params)
func _on_scores_getter_request_completed(_result, _response_code, _headers, body):
	print("Parsing scores...")
	var res = JSON.parse(body.get_string_from_utf8())
	print(body.get_string_from_utf8())
	current_user_score = res.result
	if not current_user_score == {}:
		if current_user_score.has(_tmp_uid):
			if temp_score == -1:
				temp_score = int(current_user_score[_tmp_uid])
				temp_score += t_score
			else:
				temp_score += t_score
			if tmp_current_scene != str(get_tree().current_scene):
				_upload_score()
				tmp_current_scene = str(get_tree().current_scene)
		else:
			print("that's new score")
			temp_score += 1
			temp_score += t_score
			if tmp_current_scene != str(get_tree().current_scene):
				_upload_score()
				tmp_current_scene = str(get_tree().current_scene)
	else:
		ErrorCodeServer.treat_error(ErrorCodeServer.ERROR_HTTPREQ_CANT_CONNECT, false)

func _upload_score():
	var t = {'userid': _tmp_uid, 'score': temp_score, 'game': 'Foxy Adventure'}
	var params = JSON.print(t)
	print("Posting new score")
	$scores_uploader.request("https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/leaderboard/new-score", ["Content-Type: application/json"], false, HTTPClient.METHOD_POST, params)
	t = {}
