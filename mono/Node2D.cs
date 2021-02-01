using Godot;
using System;
using System.Windows.Forms;
using System.IO;
//using System.String;

public class Node2D : Godot.Node2D
{
	[Export]
	private NodePath _nodePath;
	[Export]
	private string _name = "default";
	[Export(PropertyHint.Range, "0,100000,1000,or_greater")]
	private int _income;
	[Export(PropertyHint.File, "*.png,*.jpg")]
	private string _icon;
	[Signal]
	delegate void MySignal(string willSendsAString);
	// Declare member variables here. Examples:
	// private int a = 2;
	// private string b = "text";

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GD.Print("TEST!");
		validateUserEntry();
		fileDialog();
	}

  // Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(float delta)
	{
//		   GD.Print(s);
	}
	private void _on_Button_pressed()
	{
		GD.Print("Btn clicked");
		EmitSignal(nameof(MySignal), _name);
		GD.Print("signal emitted");
		GetArch();
	}
	void GetArch()
	{
		#if GODOT_SERVER
			GD.Print("Server");
		#elif GODOT_64
			GD.Print("64bit");
		#elif GODOT_32
			GD.Print("32bit");
		#elif GODOT_WINDOWS
			GD.Print("Windows");
		#elif GODOT_X11
			GD.Print("x11");
		#elif GODOT_OSX
			GD.Print("OSX");
		#endif
	}
	private void validateUserEntry()
	{
		// Checks the value of the text.
		// Initializes the variables to pass to the MessageBox.Show method.
		string message = "You did not enter a server name. Cancel this operation?";
		string caption = "Error Detected in Input";
		MessageBoxButtons buttons = MessageBoxButtons.YesNo;
		DialogResult result;
		// Displays the MessageBox.
		result = MessageBox.Show(message, caption, buttons);
		
	}
	void fileDialog()
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



