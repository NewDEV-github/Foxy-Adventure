using Godot;
using System;
using System.IO;
using System.Drawing;
using System.Collections.Generic;
using System.Reflection;
using System.Windows.Forms;
using System.Windows.Forms.VisualStyles;
//using System.String;

public class WindowPopupWithVisualStyles : Godot.Node2D
{
	[Export]
	private string _window_name = "Window Name";
	[Export]
	private string _window_text = "Window Text";
	[Export]
	private MessageBoxButtons _buttons =  MessageBoxButtons.YesNo;
	[Export]
	private MessageBoxIcon _icon = MessageBoxIcon.Exclamation;
	[Export]
	private bool _display_icon = true;
	[Signal]
	delegate void result(string _result);
	// Declare member variables here. Examples:
	// private int a = 2;
	// private string b = "text";

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{	
		Application.EnableVisualStyles();
	}
	public void ShowMessageBox()
	{
		// Checks the value of the text.
		// Initializes the variables to pass to the MessageBox.Show method.
		DialogResult _result;
		// Displays the MessageBox.
		if (_display_icon == true)
		{
			_result = MessageBox.Show(_window_text, _window_name, _buttons, _icon);
		}
		else
		{
			_result = MessageBox.Show(_window_text, _window_name, _buttons);
		}
		EmitSignal(nameof(result), GD.Str(_result));
	}
	void ShowOpenFileDialog()
	{
		var fileContent = string.Empty;
		var filePath = string.Empty;
		
		using (OpenFileDialog openFileDialog = new OpenFileDialog())
		{
			openFileDialog.InitialDirectory = "c:\\";
			openFileDialog.Filter = "txt files (*.txt)|*.txt|All files (*.*)|*.*";
			openFileDialog.FilterIndex = 2;
			openFileDialog.RestoreDirectory = true;
		
			if (openFileDialog.ShowDialog() == DialogResult.OK)
			{
				//Get the path of specified file
				filePath = openFileDialog.FileName;
		
				//Read the contents of the file into a stream
				var fileStream = openFileDialog.OpenFile();
		
				using (StreamReader reader = new StreamReader(fileStream))
				{
					fileContent = reader.ReadToEnd();
				}
			}
		}
	}
}



