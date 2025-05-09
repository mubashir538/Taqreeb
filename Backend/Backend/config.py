import requests

def get_public_ip():
    response = requests.get('https://docs.google.com/document/d/18nsdmLEpSqVjxJu0dhtCKfB1282H1FAYuCpM7q8eFkM/export?format=txt')
    return response.text

#ip = 'https://c1f8-202-47-47-248.ngrok-free.app'.strip()
ip = str(get_public_ip())[5:]

