using Godot;
using System;
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
}



