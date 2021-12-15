from godot import exposed, export
from godot import *
from tkinter import messagebox
from godot.bindings import *
@exposed(tool=True)
class ErrorCodeServer(Node):
	def treat(self, error_code):
		messagebox.showinfo("Foxy Adventure Error", "Error happened!\n\nError code: " + str(error_code))
