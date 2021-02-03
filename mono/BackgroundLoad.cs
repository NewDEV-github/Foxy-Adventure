using Godot;
using System;

namespace Common 
{
    
    public class BackgroundLoad : Node
    {  
        [Signal]
	    delegate void ReadyToChange(bool canChange);
        
        public static BackgroundLoad instance = null;
        Resource res;
        public bool canChange = false;
        Thread thread;
        Node newScene;
        string scenePath = "";

        public override void _Ready()
        {
            instance = this;
        }
        private void ThreadLoad(string path) {
           ResourceInteractiveLoader ril = ResourceLoader.LoadInteractive(path);
           int total = ril.GetStageCount();
           res = null;
           while(true) {
               Error err = ril.Poll();
               if (err == Error.FileEof) {
                   res = ril.GetResource();
                    canChange = true;
                    EmitSignal(nameof(ReadyToChange), canChange);
                    break;
               }
                else if (err != Error.Ok) {
                    GD.Print("ERROR LOADING");
                    break;
                }

           }
        }

        private void ClearStuff() {
            thread = null;
            newScene = null;
            scenePath = "";
            canChange = false;
            res = null;
        }
        private void ThreadDone(PackedScene packedScene) {
            thread.WaitToFinish();
            newScene = packedScene.Instance();
            GetTree().CurrentScene.Free();
            GetTree().CurrentScene = null;
            GetTree().Root.AddChild(newScene);
            GetTree().CurrentScene = newScene;
            ClearStuff();
            
        }

        public void PreloadScene(string path) {
            GD.Print("Calling new Scene");
            scenePath = path;
            canChange = false;
            thread = new Thread();
            thread.Start(this,nameof(ThreadLoad), path);
            Raise();
        }

        public void ChangeSceneToPreloaded() {
            CallDeferred(nameof(ThreadDone), res);
        }


       


    }
}
