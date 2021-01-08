import rpc
import time
from time import mktime

client_id = '467570845993271307'  # Your application's client ID as a string. (This isn't a real client ID)
rpc_obj = rpc.DiscordIpcClient.for_platform(client_id)  # Send the client ID to the rpc module
print("RPC connection successful.")

time.sleep(5)
start_time = mktime(time.localtime())
while True:
    activity = {
            "state": "Foxy Adventure",  # anything you like
            "details": "Playing",  # anything you like
            "timestamps": {
                "start": start_time
            },
            "assets": {
                "small_text": "Adobe",  # anything you like
                "small_image": "adobe",  # must match the image key
                "large_text": "Illustrator",  # anything you like
                "large_image": "Illustrator"  # must match the image key
            }
        }
    rpc_obj.set_activity(activity)
    time.sleep(30)
