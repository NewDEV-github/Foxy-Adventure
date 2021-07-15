from godot import exposed, export
from godot import *
import os

@exposed
class CFGDownloader(HTTPRequest):

	# member variables here, example:
	a = export(int)
	b = export(str, default='foo')

	def _ready(self):
		os.system("echo TESST")
		"""
		Called every time the node is added to the scene.
		Initialization here.
		"""
		pass
