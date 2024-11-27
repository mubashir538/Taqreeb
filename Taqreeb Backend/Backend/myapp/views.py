from rest_framework.response import Response
import requests as rq
from . import models as md
from django.db.models import Max
from rest_framework.views import APIView
from rest_framework import status
from . import Serializers as s


@api_view(['GET'])
def AccountSignupPage(request):
    pass

def BusinessOwnerSignup(request):
    pass

def ForgotPasswordPage(request):
    pass

def ResetPasswordPage(request):
    pass

def AccountInfoPage(request):
    pass

def ListingsPage(request):
    pass

def DecoratorDetailPage(request):
    pass

def EditAccountInfoPage(request):
    pass

def FreelancerSignup(request):
    pass

def CreateFunction(request):
    pass

def EventDetails(request):
    pass

def VenueViewPage(request):
    pass

def CreateEvent(request):
    pass

def YourEvents(request):
    pass

def PhotographerViewPage(request):
    pass

def CatererViewPage(request):
    pass

def CatererViewPage(request):
    pass

def VideoEditorViewPage(request):
    pass

def HomeCategories(request):
    pass

def HomeListings(request):
    pass

def SearchListings(request):
    pass

def SearchListings(request):
    pass

def ShowGuest(request):
    pass

def AddGuests(request):
    pass

def BusinessOwnerAccountInfo(request):
    pass


def UserLogin(request):
    pass

def CartItems(request):
    pass

def GraphicDesignerViewPage(request):
    pass

def CarRenterViewPage(request):
    pass




# @api_view(['GET','POST','PUT'])
# def user(request):
#     if request.method == 'POST':
#         if request.data.get('type') == 'basicInfo':
#             firstName = request.data.get('firstName')
#             lastName = request.data.get('lastName')
#             password = request.data.get('password')
#             user = md.User.objects.create(firstName=firstName,lastName=lastName,password=password)
#             user.save()
#             id = md.User.objects.aaggregate(Max('id'))['id__max']
#             return Response({"message":"success",'status': 200,'yourId':id})
#         elif request.data.get('type') == 'contactNumber':
#             contact = request.data.get('contactNumber')
#             # userid = request.data.get('id')
#             #user = md.User.objects.filter(id=userid).update(contact=contact)


#     elif request.method == 'GET':
#         pass
#     elif request.method == 'PUT':
#         pass
#     # print(request)
#     # return Response({"message":request.data})

def urlShortener(url):
    try:
        response = rq.get("http://tinyurl.com/api-create.php?url="+url)
        response.raise_for_status()
        return response.text
    except Exception as e:
        print(e)
        return e

    