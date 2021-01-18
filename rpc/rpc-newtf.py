import rpc
import time
from time import mktime

client_id = '800322839176937492'  # Your application's client ID as a string. (This isn't a real client ID)
rpc_obj = rpc.DiscordIpcClient.for_platform(client_id)  # Send the client ID to the rpc module
print("RPC connection successful.")

time.sleep(5)
start_time = mktime(time.localtime())
while True:
    activity = {
            "state": "Playing as New The Fox",  # anything you like
            "details": "Foxy Adventure",  # anything you like
            "timestamps": {
                "start": start_time
            },
            "assets": {
                "small_text": "Playing",  # anything you like
                "small_image": "play1",  # must match the image key
                "large_text": "New The Fox",  # anything you like
                "large_image": "qwerty"  # must match the image key
            }
        }
    rpc_obj.set_activity(activity)
    time.sleep(30)
