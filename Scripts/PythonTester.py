from godot import exposed, export
from godot import *


@exposed(tool=True)
class PythonTester(Node):

	# member variables here, example:
	a = export(int)
	b = export(str, default='foo')

	def _ready(self):
		print("Python is working!")
		pass
