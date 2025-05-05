from .. import Serializers as s
from .. import models as m
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.core.files.storage import FileSystemStorage
from django.conf import settings
import os
from myapp.firebase_db import db

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def searchType(request,userid):
    business = m.BusinessOwner.objects.filter(userID=userid,status='Approved')
    response = {'status':'success','business':False,'freelancer':False}
    if business:
        response['business'] = True
    freelancer = m.Freelancer.objects.filter(userID=userid,status='Approved')
    if freelancer:
        response['freelancer'] = True
    return Response(response)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_business_usernames(request):
    if request.method == 'GET':
        business_usernames = m.BusinessOwner.objects.values_list('businessUsername', flat=True)
        usernames_list = list(business_usernames)
        return Response({'status':'success','businessUsernames': usernames_list})
    
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def BusinessOwnerSignup(request):
    userid = request.data.get('id')
    businessName = request.data.get('businessName')
    cnic = request.data.get('cnic')
    cnicFront = request.FILES.get('cnicFront')
    cnicBack = request.FILES.get('cnicBack')
    description = request.data.get('description')
    profile = request.FILES.get('profilePicture')
    user = m.User.objects.get(id=userid)
    if m.BusinessOwner.objects.filter(userID=userid).exists():
        return Response({'status':'error', 'message': 'Business Owner Already Exists'}) 
    owner = m.BusinessOwner(userID=user,businessName=businessName,Description=description,cnic=cnic,status='Pending')
    owner.save()
    filestorage = FileSystemStorage()
    filePath = filestorage.save(f'uploads/Business/cnic/Approval/Front/{userid}.png', cnicFront)
    filePath2 = filestorage.save(f'uploads/Business/cnic/Approval/Back/{userid}.png', cnicBack)
    picture = filestorage.save(f'uploads/Business/profilePicture/{userid}.png', profile)
    owner = m.BusinessOwner.objects.get(userID=userid)
    owner.CNICBack = filestorage.url(filePath2)
    owner.CNICFront = filestorage.url(filePath)
    owner.profilepic = filestorage.url(picture)
    owner.save(update_fields=["CNICFront","CNICBack","profilepic"])
    firebase_user_data = {
        "businessName": businessName,
        "profile":picture,
        "description":description,
        "userId":userid
    }
    try:
        db.collection("businessUsers").document(str(owner.id)).set(firebase_user_data)
    except Exception as e:
        return Response({'status': 'error', 'message': f'Failed to store user data in Firebase: {str(e)}'})
    
    return Response({'status':'success'})
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def BusinessAccountInfoPage(request,id,type):
    userid = id
    user = m.User.objects.filter(id=userid).first()
    if type == 'freelancer':
        businessInfo = m.Freelancer.objects.get(userID=id)
        BusinessSerializer = s.FreelancerSerializer(businessInfo,many=False)
    else:
        businessInfo = m.BusinessOwner.objects.get(userID=id)
        BusinessSerializer = s.BusinessOwnerSerializer(businessInfo,many=False)
    serializer = s.UserSerializer(user,many=False)
    if type == 'freelancer':
        types = list(m.Listing.objects.filter(freelancerID=businessInfo.id).values_list('type', flat=True).distinct())
        listing = m.Listing.objects.filter(freelancerID=businessInfo.id).count()
    else:
        types = list(m.Listing.objects.filter(ownerID=businessInfo.id).values_list('type', flat=True).distinct())
        listing = m.Listing.objects.filter(ownerID=businessInfo.id).count()
    return Response({'status':'success','businessInfo':BusinessSerializer.data,'userinfo':serializer.data,'categories':list(types),'listingCount':listing})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def editBusinessInfo(request):
    userid = request.data.get('userid')
    businessName = request.data.get('name')
    Description = request.data.get('description')
    type = request.data.get('type')
    user = m.User.objects.get(id=userid)
    if type == 'freelancer':
        business = m.Freelancer.objects.get(userID=user)
    else:
        business = m.BusinessOwner.objects.get(userID=user)
    business.businessName = businessName
    business.Description = Description
    profilePicture = request.FILES.get('profilePicture')
    
    if profilePicture:
        relative_path = business.profilepic.replace('/media/', '', 1) 
        full_path = os.path.join(settings.MEDIA_ROOT, relative_path)
        full_path = full_path.replace('\\', '/')
        if os.path.exists(full_path):
            os.remove(full_path)
        filestorage = FileSystemStorage()
        if type == 'freelancer':
            filePath = filestorage.save(f'uploads/Business/profilePicture/{user.id}.png', profilePicture)
        else:
            filePath = filestorage.save(f'uploads/Freelancer/profilePicture/{user.id}.png', profilePicture)
        business.profilepic = filestorage.url(filePath)   
        business.save(update_fields=["profilepic",'businessName','Description'])
    else:
        business.save(update_fields=['businessName','Description'])
    
    return Response({'status':'success','profilepic':business.profilepic})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def FreelancerSignup(request):
    BusinessName = request.data.get('BusinessName')
    PortfolioLink = request.data.get('Portfoliolink')
    Description = request.data.get('Description')
    Picture = request.FILES.get('profilePicture')
    UserId = request.data.get('UserId')
    cnic = request.data.get('cnic')
    user = m.User.objects.get(id=UserId)
    Freelancer = m.Freelancer(userID = user,businessName = BusinessName,cnic=cnic,portfolioLink = PortfolioLink,Description = Description,status='Pending')
    Freelancer.save()
    filestorage = FileSystemStorage()
    picture = filestorage.save(f'uploads/Freelancer/profilePicture/{UserId}.png',Picture)
    owner = m.Freelancer.objects.get(userID=UserId)
    owner.profilepic = filestorage.url(picture)
    owner.save(update_fields=["profilepic"])
    firebase_user_data = {
        "businessName": BusinessName,
        "profile":owner.profilepic,
        "description":Description,
        "userId":UserId
    }
    try:
        db.collection("freelanceUsers").document(str(owner.id)).set(firebase_user_data)
    except Exception as e:
        return Response({'status': 'error', 'message': f'Failed to store user data in Firebase: {str(e)}'})
    
    return Response({'status': 'success'})
