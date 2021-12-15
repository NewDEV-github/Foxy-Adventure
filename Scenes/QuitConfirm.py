from godot import exposed, export
from godot import *
from tkinter import messagebox
from godot.bindings import *
@exposed(tool=True)
class QuitConfirm(Node):

	# member variables here, example:
	a = export(int)
	b = export(str, default='foo')

	def quitask(self):
		messagebox.askquestion('Foxy Adventure','Are you sure you want to exit the application?',icon = 'warning')
	def restartask(self):
		messagebox.askquestion('Foxy Adventure','Are you sure you want to restart the application?',icon = 'warning')
	def dlcrestartask(self, dlc_name):
		messagebox.askquestion('Foxy Adventure','DLC '+str(dlc_name)+' needs to restart Foxy Adventure.\n\nDo You want to restart the game now?',icon = 'warning')
