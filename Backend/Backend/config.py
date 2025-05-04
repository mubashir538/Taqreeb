import requests

def get_public_ip():
    response = requests.get('https://api.ipify.org?format=json')
    return response.json()['ip']

#ip = 'https://c1f8-202-47-47-248.ngrok-free.app'.strip()
ip = 'http://192.168.18.77'

