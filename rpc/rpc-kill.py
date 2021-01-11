import rpc
import time
from time import mktime

client_id = '729429191489093702'  # Your application's client ID as a string. (This isn't a real client ID)
rpc_obj = rpc.DiscordIpcClient.for_platform(client_id)  # Send the client ID to the rpc module
print("RPC connection successful.")
rpc_obj.close()