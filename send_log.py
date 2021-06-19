import requests
from appdirs import *
import easygui
import platform
from os import walk

def cumpute_file_path():
    appauthor = "Godot"
    appname = "app_userdata"
    if platform.system() == 'Windows':
        file_path = user_data_dir(appname, appauthor, roaming=True)
    elif platform.system() == 'Darwin' or platform.system() == 'Linux':
        file_path = user_data_dir(appname, appauthor)
    file_path += '/Foxy Adventure/logs/'
    f = []
    for (dirpath, dirnames, filenames) in walk(file_path):
        f.extend(filenames)
        break
    file_path += f[1]
    return file_path
def prepare_log(file):
    f = open(file, "r")
    log_text = f.read()
    return log_text
def send_log(l_text):
    params = {'log_text': l_text, 'game': 'FoxyAdventure'}
    url = "https://us-central1-api-9176249411662404922-339889.cloudfunctions.net/logs/send-log/"
    r = requests.post(url, data=params)
    return r.text
if __name__ == '__main__':
    log_id = send_log(prepare_log(cumpute_file_path()))
    # print(str(log_id))
    easygui.msgbox(
        'Your log was sent!\n\nLog id is: '+ str(log_id),
        'Foxy Adventure Crash Report'
    )
