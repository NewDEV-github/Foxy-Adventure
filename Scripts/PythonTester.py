from godot import exposed, export
from godot import *


@exposed(tool=True)
class PythonTester(Node):
	def _ready(self):
		print("Python is working!")
		pass
