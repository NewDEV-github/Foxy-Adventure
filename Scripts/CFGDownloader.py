from godot import exposed, export
from godot import *
import os
from fpdf import FPDF
@exposed
class FMODPlayer(Node):

	# member variables here, example:
	a = export(int)
	b = ['d', 'f']

	def _ready(self):
		#print(b)
		"""
		Called every time the node is added to the scene.
		Initialization here.
		"""
		a = 4
		print(str(a))
		for i in self.b:
			print(i)
		print(self.b)
