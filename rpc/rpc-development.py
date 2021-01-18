import rpc
import time
from time import mktime

client_id = '729429191489093702'  # Your application's client ID as a string. (This isn't a real client ID)
rpc_obj = rpc.DiscordIpcClient.for_platform(client_id)  # Send the client ID to the rpc module
print("RPC connection successful.")

time.sleep(5)
start_time = mktime(time.localtime())
while True:
    activity = {
            "state": "Coding",  # anything you like
            "details": "Godot Engine",  # anything you like
            "timestamps": {
                "start": start_time
            },
            "assets": {
                "small_text": "Coding",  # anything you like
                "small_image": "code",  # must match the image key
                "large_text": "Godot Engine",  # anything you like
                "large_image": "godot"  # must match the image key
            }
        }
    rpc_obj.set_activity(activity)
    time.sleep(30)
