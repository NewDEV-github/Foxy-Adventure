from godot import exposed, export, OS
from godot import *
import zipfile
from pathlib import Path
import shutil
import os

@exposed(tool=True)
class unzipper(Node):
	def _ready(self):
		print("Python is working!")
		pass
	extracted_file = signal()
	extraction_finished = signal()
	def unzip_update(self, path_to_zip_file, text_displayer):
		with zipfile.ZipFile(str(path_to_zip_file), 'r') as zip_ref:
			directory_to_extract_to = str(OS.get_user_data_dir()) + str("/updates/_tmp/") + str(Path(str(path_to_zip_file)).stem)
			print(str("Extracting to: ") + str(directory_to_extract_to))
			for i in zip_ref.namelist():
				self.call("emit_signal", "extracted_file", i)
				zip_ref.extract(str(i), str(directory_to_extract_to))
		directory_to_copy_to = str(Path(str(OS.get_executable_path())).parent.resolve())
		shutil.copytree(directory_to_extract_to, directory_to_copy_to)

