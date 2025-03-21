import requests

def get_public_ip():
    response = requests.get('https://api.ipify.org?format=json')
    return response.json()['ip']

ip = 'https://4bee-2400-adc1-163-8a00-9c50-6ad8-45d1-a73b.ngrok-free.app'
#ip = 'http://192.168.18.77:8000'