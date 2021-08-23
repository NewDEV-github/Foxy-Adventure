import requests
params = {'game_name': "test", 'game': 'Foxy testAdventure', "server_ip": "test"}
url = "https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/db/create_online_game"
r = requests.post(url, data=params)
print(r.text)
#params = {'log_text': l_text, 'game': 'FoxyAdventure'}
url = "https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/db/get_all_online_games_data"
r = requests.get(url)
print(r.text)