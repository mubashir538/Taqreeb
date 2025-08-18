
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.core.files.storage import FileSystemStorage
from django.conf import settings
import os
from myapp.firebase_db import db
from ..Serializers.business_serializers import BusinessOwnerSerializer,FreelancerSerializer 
from ..models.business_models import BusinessOwner,Freelancer
from ..models.user_models import User
from ..Serializers.auth_serializers import UserSerializer
from ..models.listing_models import Listing
from datetime import datetime

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def search_type(request,userid):
    business = BusinessOwner.objects.filter(userID=userid,status='Approved')
    response = {'status':'success','business':False,'freelancer':False}
    if business:
        response['business'] = True
    freelancer = Freelancer.objects.filter(userID=userid,status='Approved')
    if freelancer:
        response['freelancer'] = True
    return Response(response)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_business_usernames(request):
    if request.method == 'GET':
        business_usernames = BusinessOwner.objects.values_list('businessUsername', flat=True)
        usernames_list = list(business_usernames)
        return Response({'status':'success','businessUsernames': usernames_list})
    
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def business_owner_signup(request):
    userid = request.data.get('id')
    business_name = request.data.get('businessName')
    cnic = request.data.get('cnic')
    cnic_front = request.FILES.get('cnicFront')
    cnic_back = request.FILES.get('cnicBack')
    description = request.data.get('description')
    profile = request.FILES.get('profilePicture')
    user = User.objects.get(id=userid)
    if BusinessOwner.objects.filter(userID=userid).exists():
        return Response({'status':'error', 'message': 'Business Owner Already Exists'}) 
    owner = BusinessOwner(userID=user,businessName=business_name,Description=description,cnic=cnic,status='Pending')
    owner.save()
    filestorage = FileSystemStorage()
    file_path = filestorage.save(f'uploads/Business/cnic/Approval/Front/{userid}.png', cnic_front)
    file_path2 = filestorage.save(f'uploads/Business/cnic/Approval/Back/{userid}.png', cnic_back)
    now = datetime.now().strftime('%Y%m%d_%H%M%S')
    picture = filestorage.save(f'uploads/Business/profilePicture/{userid}_{now}.png', profile)
    owner = BusinessOwner.objects.get(userID=userid)
    owner.CNICBack = filestorage.url(file_path2)
    owner.CNICFront = filestorage.url(file_path)
    owner.profilepic = filestorage.url(picture)
    owner.save(update_fields=["CNICFront","CNICBack","profilepic"])
    firebase_user_data = {
        "businessName": business_name,
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
def business_account_info_page(request,id,type):
    userid = id
    user = User.objects.filter(id=userid).first()
    if type == 'freelancer':
        business_info = Freelancer.objects.get(userID=id)
        business_serializer = FreelancerSerializer(business_info,many=False)
    else:
        business_info = BusinessOwner.objects.get(userID=id)
        business_serializer = BusinessOwnerSerializer(business_info,many=False)
    serializer = UserSerializer(user,many=False)
    if type == 'freelancer':
        types = list(Listing.objects.filter(freelancerID=business_info.id).values_list('type', flat=True).distinct())
        listing = Listing.objects.filter(freelancerID=business_info.id).count()
    else:
        types = list(Listing.objects.filter(ownerID=business_info.id).values_list('type', flat=True).distinct())
        listing = Listing.objects.filter(ownerID=business_info.id,status='active').count()
    return Response({'status':'success','businessInfo':business_serializer.data,'userinfo':serializer.data,'categories':list(types),'listingCount':listing})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def edit_business_info(request):
    userid = request.data.get('userid')
    business_name = request.data.get('name')
    description = request.data.get('description')
    user_type = request.data.get('type')
    user = User.objects.get(id=userid)
    print(user_type)
    if user_type == 'freelancer':
        business = Freelancer.objects.get(userID=user)
    else:
        business = BusinessOwner.objects.get(userID=user)
    business.businessName = business_name
    business.Description = description
    profile_picture = request.FILES.get('profilePicture')
    
    if profile_picture:
        relative_path = business.profilepic.replace('/media/', '', 1) 
        full_path = os.path.join(settings.MEDIA_ROOT, relative_path)
        full_path = full_path.replace('\\', '/')
        if os.path.exists(full_path):
            os.remove(full_path)
        filestorage = FileSystemStorage()
        now = datetime.now().strftime('%Y%m%d_%H%M%S')
        if user_type == 'freelancer':
            file_path = filestorage.save(f'uploads/Business/profilePicture/{user.id}_{now}.png', profile_picture)
        else:
            file_path = filestorage.save(f'uploads/Freelancer/profilePicture/{user.id}_{now}.png', profile_picture)
        business.profilepic = filestorage.url(file_path)   
        business.save(update_fields=["profilepic",'businessName','Description'])
    else:
        business.save(update_fields=['businessName','Description'])
    
    return Response({'status':'success','profilepic':business.profilepic})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def freelancer_signup(request):
    business_name = request.data.get('BusinessName')
    portfolio_link = request.data.get('Portfoliolink')
    description = request.data.get('Description')
    picture = request.FILES.get('profilePicture')
    user_id = request.data.get('UserId')
    cnic = request.data.get('cnic')
    user = User.objects.get(id=user_id)
    freelancer = Freelancer(userID = user,businessName = business_name,cnic=cnic,portfolioLink = portfolio_link,Description = description,status='Pending')
    freelancer.save()
    filestorage = FileSystemStorage()
    now = datetime.now().strftime('%Y%m%d_%H%M%S')
    picture = filestorage.save(f'uploads/Freelancer/profilePicture/{user_id}_{now}.png',picture)
    owner = Freelancer.objects.get(userID=user_id)
    owner.profilepic = filestorage.url(picture)
    owner.save(update_fields=["profilepic"])
    firebase_user_data = {
        "businessName": business_name,
        "profile":owner.profilepic,
        "description":description,
        "userId":user_id
    }
    try:
        db.collection("freelanceUsers").document(str(owner.id)).set(firebase_user_data)
    except Exception as e:
        return Response({'status': 'error', 'message': f'Failed to store user data in Firebase: {str(e)}'})
    
    return Response({'status': 'success'})
