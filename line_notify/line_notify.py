from datetime import datetime
import json
import numpy as np
import pandas as pd
import requests
import sys

args = sys.argv

JSON_PATH = args[1]
TOKEN = args[2]

def read_json(json_path):
    json_open = open(json_path, 'r')
    json_load = json.load(json_open)
    
    return json_load

def arange_tasks(json_path):
    df = pd.DataFrame(read_json(json_path)).sort_values(by="deadline").reset_index(drop=True)
    df = df[df["done"] != True].drop(['done', 'id', 'published'], axis=1)
    return df

def create_message(json_path):
    
    df = arange_tasks(JSON_PATH)
    
    if len(df) > 0:
        message = f'\n期限が迫っているタスクは残り{len(df)}つです。\n \n{df.to_string(index=None)}'
    else:
        message = None
    
    return message

def send_line(access_token, message):
    if message is None:
        return 
    
    url = "https://notify-api.line.me/api/notify"
    headers = {'Authorization': 'Bearer ' + access_token}
    
    payload = {
        'message': message,
        'stickerPackageId': 1,
        'stickerId': np.random.choice(np.arange(1, 18)),
        }
    r = requests.post(url, headers=headers, params=payload,)
    
if __name__ == '__main__':
    message = create_message(JSON_PATH)
    send_line(TOKEN, message)
    