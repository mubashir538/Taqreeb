import requests

def get_public_ip():
    response = requests.get('https://api.ipify.org?format=json')
    return response.json()['ip']


ip = 'http://192.168.77.224'