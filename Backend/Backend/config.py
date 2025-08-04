import requests

def get_public_ip():
    response = requests.get('https://docs.google.com/document/d/1Mhizi_P-xZyllsPCWAGjkmtWK9FC_IVM54GqO5Ifefg/export?format=txt')
    return response.text

ip = 'https://8ee9a64b92bb.ngrok-free.app'.strip()
# ip_got =  str(get_public_ip()).strip()
# ip = ip_got.lstrip('\ufeff')

