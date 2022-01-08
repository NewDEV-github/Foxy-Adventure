from godot import exposed, export
from godot import *
import json
import requests

@exposed(tool=True)
class issues_api(Control):
	# member variables here, example:
	a = export(int)
	b = export(str, default='foo')
	def make_github_issue(self, title, body=None, labels=None, token=None):
		'''Create an issue on github.com using the given parameters.'''
		# Our url to create issues via POST
		url = 'https://api.github.com/repos/%s/%s/issues' % ('NewDEV-github', "Foxy-Adventure")
		# Create an authenticated session to create the issue
		session = requests.session()
		session.auth = requests.auth.HTTPDigestAuth('FoxyAdventureBugTracker', 'DoS20211234')
		# Create our issue
		issue = {'title': str(title),
				'body': str(body),
				'labels': str(labels).split(', ')}
		print(issue)
		# Add the issue to our repository
		r = session.post(url, json.dumps(issue), headers={'Authorization':'token ' + str(token)})
		if r.status_code == 201:
			print('Successfully created Issue "%s"' % title)
		else:
			print('Could not create Issue "%s"' % title)
			print('Response:', r.content)
