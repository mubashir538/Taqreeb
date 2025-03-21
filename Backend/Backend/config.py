import requests

def get_public_ip():
    response = requests.get('https://api.ipify.org?format=json')
    return response.json()['ip']

# ip = 'https://984f-182-176-107-231.ngrok-free.app'
ip = 'http://192.168.0.105'
