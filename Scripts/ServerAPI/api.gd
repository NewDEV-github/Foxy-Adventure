extends HTTPRequest


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
var current_user_score
signal scoredatarecived
var temp_score = -1 #we cannot get minus scores in the game so if this is -1 means, score was not given to the game by api
var _tmp_uid
var tmp_current_scene = ""
func update_score(uid, score):
	_tmp_uid = uid
	connect("request_completed", self, "get_scores")
	request("https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/app/api/foxyadventure/leaderboard-all-scores")
	yield(self, "request_completed")
	if temp_score == -1:
		temp_score = int(current_user_score[uid])
		temp_score += score
	else:
		temp_score += score
	disconnect("request_completed", self, "get_scores")
	if tmp_current_scene != str(get_tree().current_scene):
		_upload_score()
		tmp_current_scene = str(get_tree().current_scene)
func get_scores(result, _response_code, _headers, body):
	var res = JSON.parse(body.get_string_from_utf8())
	current_user_score = res.result

func _upload_score():
	var t = {'userid': _tmp_uid, 'score': temp_score}
	var params = JSON.print(t)
	print("Posting new score")
	request("https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/app/api/foxyadventure/leaderboard-new-score", ["Content-Type: application/json"], false, HTTPClient.METHOD_POST, params)
	t = {}
