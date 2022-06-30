extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (String) var repo_name = ""
export (String) var repo_owner = ""
# Called when the node enters the scene tree for the first time.
func make_github_issue(title:String, body:String, labels, token) -> void:
	var url = 'https://api.github.com/repos/%s/%s/issues' % [repo_owner, repo_name]
	print("Requesting %s..." % url)
	var issue_content = {'title': str(title),
		'body': str(body),
		'labels': str(labels).split(', ')
	}
	var query = JSON.print(issue_content)
	var headers = ['Authorization: token ' + str(token)]
	$IssueRequest.request(url, headers, true, HTTPClient.METHOD_POST, query)
func _on_IssueRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
