extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var userdata = {}
var scorelist = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	get_data()


func get_data():
	$Userdata.request('https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/db/get_users_data')
	yield($Userdata, "request_completed")
	var t = {'game': 'Foxy Adventure'}
	var params = JSON.print(t)
	$Scorelist.request("https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/leaderboard/get-scores", ["Content-Type: application/json"], false, HTTPClient.METHOD_POST, params)
	yield($Scorelist, "request_completed")
	render_board()
#func _on_Userdata_request_completed(result, response_code, headers, body):
#	var res = JSON.parse(body.get_string_from_utf8())
#	userdata = res.result
##	print("USERDATA: " + str(userdata))


#func _on_Scorelist_request_completed(result, response_code, headers, body):
#	var res = JSON.parse(body.get_string_from_utf8())
#	scorelist = res.result
##	print("sSCORELIST: " + str(scorelist))

func get_username_or_email_by_uid(uid:String):
	if not userdata == null or userdata == {}:
		for i in userdata:
			if i == uid:
				var tmp_userdata = userdata[i]
				print(tmp_userdata)
				if tmp_userdata.has('username'):
					return tmp_userdata['username']
				elif tmp_userdata.has('username') == false:
					return tmp_userdata['email']
var number = 1
func render_board():
#	var scorelist_values = scorelist.values()
#	scorelist_values.sort_custom(Sorter, "sort_ascending")
#	var scorelist_keys = scorelist.keys()
#	for i in scorelist:
#		#get user id
#		var _uid = i
#		#find score
#		var _score = scorelist[_uid]
#		# get score position in board
#		var _score_position = scorelist_values.find(_score)
#		#move uid to right position
#		scorelist_keys.remove(scorelist_keys.find(_uid))
#		scorelist_keys.insert(i, _score_position)
#	print(scorelist_keys)
##	scorelist_keys.sort_custom(Sorter, "sort_ascending")
#	var temp_scorelist = {}
#	var tmp_n = 0
#	for i in scorelist_values:
#		if scorelist_keys.size() >= tmp_n:
#			temp_scorelist[i] = scorelist_keys[tmp_n]
#			tmp_n += 1
#
#	print("TEMP SCORELIST: " + temp_scorelist)
#	#WE NEED TO REPLACE NULL SCORE WITH 1ST (FROM LIST BEGINNING) USER'S SCORE
##	var _tmp_null_score = temp_scorelist["null"]
##	print("TEMP SCORELIST: " + temp_scorelist)
#	for i in temp_scorelist:
#		print(i)
#		print("Found score from %s: %s" % [get_username_or_email_by_uid(temp_scorelist[i]), i])
#		$ItemList.add_item("%s. %s: %s" % [number, get_username_or_email_by_uid(temp_scorelist[i]),i])
#		number += 1

	pass
class Sorter:
	static func sort_ascending(a, b):
		if a > b:
			return true
		return false

