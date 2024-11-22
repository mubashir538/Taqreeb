from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.decorators import api_view
import requests as rq

# Create your views here.

@api_view(['GET'])
def home(request):
    return Response(
        {'response':'hello',
         'Page Name':'Home Page'}
        )


def urlShortener(url):
    try:
        response = rq.get("http://tinyurl.com/api-create.php?url="+url)
        response.raise_for_status()
        return response.text
    except Exception as e:
        print(e)
        return e

    