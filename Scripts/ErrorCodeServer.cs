
using System;
using Godot;
using Dictionary = Godot.Collections.Dictionary;
using Array = Godot.Collections.Array;


public class ErrorCodeServer : Node
{
	 
	public bool treatOnAndroid = false;
	
	
	public const string ERRORMissingWriteReadPermissions = "0x0000";
	public const string ERRORMissingDataFiles = "0x0001";
	public const string ERRORSavingData = "0x0002";
	public const string ERRORLoadingData = "0x0003";
	public const string ERRORDownloadingData = "0x0004";
	public const string ERRORInitializingGame = "0x0005";
	public const string ERRORGameData = "0x0006";
	public const string ERRORHttpreqCantConnect = "0x0007";
	public const string ERRORHttpreqNoResponse = "0x0008";
	public const string ERRORHttpreqCantWrite = "0x0009";
	public const string ERRORHttpreqCantOpen = "0x0010";
	public const string ERRORHttpreqCantResolve = "0x0011";
	public const string ERRORHttpreqConnectionErr = "0x0012";
	public const string CONFIGFileErrorMissingSection = "0x1000";
	public const string CONFIGFileErrorMissingSectionKey = "0x1001";
	public const string CONFIGFileErrorMissingSectionValue = "0x1002";
	public const string FILEErr = "0x2000";
	public const string FILEErrAlreadyInUse = "0x2001";
	public const string FILEErrLocked = "0x2002";
	public const string FILEErrCorrupted = "0x2003";
	public const string ERRPcOnFire = "You'r PC is being burned now";
	public const string ERRWtf = "WTF?!";
	// Called when the node enters the scene tree for the first time.
	public void TreatError(__TYPE errorCode)
	{  
		GD.Print("Error happened!\n\nError code: " + GD.Str(errorCode));
		if(GD.Str(OS.GetName()) == "Android" && treatOnAndroid)
		{
			OS.Alert("Error c occured\n\nError code: " + GD.Str(errorCode), "Oops!");
	
	
		}
	}
	
	
	
}