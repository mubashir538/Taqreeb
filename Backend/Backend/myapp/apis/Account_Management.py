import bcrypt
from django.core.mail import send_mail
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny,IsAuthenticated
from myapp import models as m
from django.core.files.storage import FileSystemStorage
from myapp import Serializers as s
import re
import random as rd
from firebase_admin import credentials, firestore, initialize_app,messaging
import os
from django.conf import settings


cred = credentials.Certificate(os.getenv('firebase_PATH'))
firebase_app = initialize_app(cred)
db = firestore.client()

@api_view(['POST'])
@permission_classes([AllowAny])
def AccountSignupPage(request):
    firstName = request.data.get('firstName')
    lastName = request.data.get('lastName')
    password = request.data.get('password')
    age = request.data.get('age')
    contactType = request.data.get('contactType')
    city = request.data.get('city')
    gender = request.data.get('gender')
    profilePicture = request.FILES.get('profilePicture')
    username = generateUsername(firstName,lastName)
    salt = bcrypt.gensalt()
    hashed = bcrypt.hashpw(str(password).encode(),salt)
    password = hashed.decode()
    if contactType=='email':
        contact = request.data.get('email')
        user = m.User.objects.filter(email=contact).first()
        if user:
            return Response({'status':'error', 'message': 'Email Already Exists'})
        user = m.User(firstName=firstName,lastName=lastName,password=password,email=contact,city=city,gender=gender,age=age,username=username)
    else:
        contact = request.data.get('contactNumber')
        user = m.User.objects.filter(contactNumber=contact).first()
        if user:
            return Response({'status':'error', 'message': 'Contact Already Exists'})

        user = m.User(firstName=firstName,lastName=lastName,password=password,contactNumber=contact,city=city,gender=gender)
    user.save()
    if contactType=='email':
        user = m.User.objects.filter(email=contact).first()
    else:
        user = m.User.objects.filter(contactNumber=contact).first()

    if profilePicture:
            filestorage = FileSystemStorage()
            filePath = filestorage.save(f'uploads/users/profilePicture/{user.id}.png', profilePicture)
            user.profilePicture = filestorage.url(filePath)   
            user.save(update_fields=["profilePicture"])
    
    firebase_user_data = {
        "firstName": firstName,
        "lastName": lastName,
        "username": username,
        "age":age,
        "email": contact if contactType == 'email' else None,
        "contactNumber": contact if contactType != 'email' else None,
        "city": city,
        "gender": gender,
        "profilePicture": user.profilePicture if profilePicture else None,
    }
    try:
        db.collection("users").document(str(user.id)).set(firebase_user_data)
    except Exception as e:
        return Response({'status': 'error', 'message': f'Failed to store user data in Firebase: {str(e)}'})
    refresh = RefreshToken.for_user(user)
    id = user.id    
    return Response({'status':'success','refresh':str(refresh),'access':str(refresh.access_token),'userId':id})

@api_view(['POST'])
@permission_classes([AllowAny])
def resendOTPEmail(request):
    email = request.data.get('email')
    otp = request.data.get('otp')
    subject = 'OTP for Taqreeb'
    message = f''' The Otp for your Taqreeb App is
    YOUR OTP IS: {otp}'''
    email_from = settings.EMAIL_HOST_USER
    email_to = email
    try:
        send_mail(subject,message,email_from,[email_to])
        return Response({'status': 200,'otp':otp,'email':email})
    except Exception as e:
        print(e)
        return Response({'status': 400})

@api_view(['POST'])
@permission_classes([AllowAny])
def resendOTPPhone(request):
    contactNumber = request.data.get('phone')
    otp = request.data.get('otp')
    # client = Client(settings.TWILIO_ACCOUNT_SID, settings.TWILIO_AUTH_TOKEN)
    # message = client.messages.create(
    #     body=f"Your OTP for Taqreeb is {otp}",
    #     from_=settings.TWILIO_PHONE_NUMBER,
    #     to=contactNumber
    # )
    return Response({'status':'success','otp': otp,'contact':contactNumber})

@api_view(['POST'])
@permission_classes([AllowAny])
def sendOTPPhone(request):
    contactNumber = request.data.get('contactNumber')
    country = '+92'
    if contactNumber.find(country) == -1:
        if contactNumber[0] == '0':
            contactNumber = contactNumber[1:]
        contactNumber = country + contactNumber
    print('contactNumber: ',contactNumber)
    otp = rd.randint(100000,999999)
    message = messaging.Message(
            notification=messaging.Notification(
                title="Your OTP Code",
                body=f"Your Taqreeb verification code is {otp}. Do not share it with anyone."
            ),
            token=contactNumber,  # Phone number should be FCM token from the mobile app
        )

    response = messaging.send(message)
    print(response)
    # client = Client(settings.TWILIO_ACCOUNT_SID, settings.TWILIO_AUTH_TOKEN)
    # message = client.messages.create(
    #     body=f"Your OTP for Taqreeb is {otp}",
    #     from_=settings.TWILIO_PHONE_NUMBER,
    #     to=contactNumber
    # )
    return Response({'status':'success','otp': otp,'contact':contactNumber})

@api_view(['POST'])
@permission_classes([AllowAny])
def sendOTPEmail(request):
    email = request.data.get('email')
    if not m.User.objects.filter(email=email).exists():
        otp = rd.randint(1000,9999)
        subject = 'The OTP for Taqreeb'
        message = f''' The Otp for your Taqreeb App is
        YOUR OTP IS: {otp}'''
        email_from = settings.EMAIL_HOST_USER
        email_to = email
        try:
            send_mail(subject,message,email_from,[email_to])
            return Response({'status': 'success','otp':otp,'email':email})
        except Exception as e:
            print(e)
            return Response({'status': 'error'})
    else:
        return Response({'status': 'error','message': 'Email Already Exists'})

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

@api_view(['POST'])
@permission_classes([AllowAny])
def ForgotPasswordPage(request):
    contact = request.data.get('email')
    if request.data.get('email'):
        contact = request.data.get('email')
    else:
        contact = request.data.get('phone')
    otp = rd.randint(1000,9999)
    if str(contact).find('@') != -1:
        user = m.User.objects.filter(email=contact).first()
        otp = rd.randint(1000,9999)
        subject = 'Password Reset OTP for Taqreeb'
        message = f''' The Passowrd Reset Otp for your Taqreeb App is
        YOUR OTP IS: {otp}'''
        email_from = settings.EMAIL_HOST_USER
        email_to = contact
        try:
            send_mail(subject,message,email_from,[email_to])
            return Response({'status': 'success','otp':otp,'email':contact})
        except Exception as e:
            print(e)
            return Response({'status': 'error'})
    else:
        user = m.User.objects.filter(contactNumber=contact).first()
        # OTP Send Contact Number
    if user != None:
        return Response({'status':'error', 'message': 'Enter a Valid Email or Phone Number'})
    else:
        return Response({'status':'success','otp':otp,'userid':user.id})

@api_view(['POST'])
@permission_classes([AllowAny])
def resendOTP(request):
    email = request.data.get('email')
    otp = request.data.get('otp')
    if str(email).find('@') != -1:
        subject = 'The OTP for Taqreeb'
        message = f''' The Otp for your Taqreeb App is
        YOUR OTP IS: {otp}'''
        email_from = settings.EMAIL_HOST_USER
        email_to = email
        try:
            send_mail(subject,message,email_from,[email_to])
            return Response({'status': 'success','otp':otp,'email':email})
        except Exception as e:
            print(e)
            return Response({'status': 'error'})
    else:
        return Response({'status':'error', 'message': 'Enter a Valid Email or Phone Number'})


@api_view(['POST'])
@permission_classes([AllowAny])
def googleAuth(request):
    email = request.data.get('email')
    name = request.data.get('name')
    picture = request.data.get('picture')
    phone = request.data.get('phone')
    gender = request.data.get('gender')
    age = request.data.get('age')
    if not m.User.objects.filter(email=email).exists():
        firstName = name.split(' ')[0]
        lastName = name.split(' ')[1]
        username = generateUsername(firstName,lastName)
        if not m.User.objects.filter(email=email).exists():
            m.User(firstName=firstName,lastName=lastName,contactNumber=phone,email=email,city='Karachi',gender=gender,age=age,username=username).save()
            user = m.User.objects.filter(email=email).first()
            firebase_user_data = {
                "firstName": firstName,
                "lastName": lastName,
                "username": username,
                "age":age,
                "email": email,
                "contactNumber": phone,
                "city": 'Karachi',
                "gender": gender,
                "profilePicture": picture,
            }
            try:
                db.collection("users").document(str(user.id)).set(firebase_user_data)
            except Exception as e:
                return Response({'status': 'error', 'message': f'Failed to store user data in Firebase: {str(e)}'})
        refresh = RefreshToken.for_user(user)
        id = user.id    
        return Response({'status':'success','refresh':str(refresh),'access':str(refresh.access_token),'userId':id})
    else:
        user = m.User.objects.filter(email=email).first()
        refresh = RefreshToken.for_user(user)
        id = user.id
        return Response({'status':'success','refresh':str(refresh),'access':str(refresh.access_token),'userId':id})

@api_view(['POST'])
@permission_classes([AllowAny])
def ResetPasswordPage(request):
    password = request.data.get('password')
    salt = bcrypt.gensalt()
    hashed = bcrypt.hashpw(str(password).encode(),salt)
    password = hashed.decode() 
    id = request.data.get('contact')
    if str(id).find('@') != -1:
        user = m.User.objects.get(email=id)
    else:
        user = m.User.objects.get(contactNumber=id)
    user.password = password
    user.save(update_fields=["password"])
    return Response({'status':'success'})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def AccountInfoPage(request,id):
    userid = id
    user = m.User.objects.filter(id=userid).first()
    serializer = s.UserSerializer(user)
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_basic_userinfo(request,id):
    userid = id
    user = m.User.objects.filter(id=userid).first()
    return Response({'name':f'{user.firstName.capitalize()} {user.lastName.capitalize()}','profilePicture':user.profilePicture})


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
def EditAccountInfoPage(request):
    userid = request.data.get('userid')
    firstName = request.data.get('firstName')
    profilePicture = request.data.get('profilePicture')
    gender = request.data.get('gender')
    city = request.data.get('city')
    lastname = request.data.get('lastName')
    user = m.User.objects.get(id=userid)
    user.firstName = firstName
    user.lastName = lastname
    user.gender = gender
    user.city = city
    if profilePicture:
        full_path = os.path.join(settings.MEDIA_ROOT, user.profilePicture)
        if os.path.exists(full_path):
            os.remove(full_path)
        filestorage = FileSystemStorage()
        filePath = filestorage.save(f'uploads/users/profilePicture/{user.id}.png', profilePicture)
        user.profilePicture = filestorage.url(filePath)   
        user.save(update_fields=["profilePicture",'firstName','lastName','gender','city'])
    else:
        user.save(update_fields=['firstName','lastName','gender','city'])
    user = m.User.objects.get(id=userid)
    firebase_user_data = {
        "firstName": user.firstName,
        "lastName": user.lastName,
        "username": user.username,
        "age":user.age,
        "email": user.email,
        "contactNumber": user.contactNumber,
        "city": user.city,
        "gender": user.gender,
        "profilePicture": user.profilePicture if user.profilePicture else None,
    }
    try:
        db.collection("users").document(str(user.id)).set(firebase_user_data)
    except Exception as e:
        return Response({'status': 'error', 'message': f'Failed to store user data in Firebase: {str(e)}'})

    
    return Response({'status':'success'})

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
        full_path = os.path.join(settings.MEDIA_ROOT, business.profilepic)
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
    
    return Response({'status':'success'})

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

@api_view(['POST'])
@permission_classes([AllowAny])
def UserLogin(request):
    contact = request.data.get('contact')
    password = request.data.get('password')
    print('pass: ',password)
    if contact.find('@') != -1:
        user = m.User.objects.filter(email=contact).first()
    else:
        user = m.User.objects.filter(contactNumber=contact).first()
    if(user):
        if bcrypt.checkpw(password.encode(), user.password.encode()):
            refresh = RefreshToken.for_user(user)
            return Response({'status':'success','refresh': str(refresh),'access': str(refresh.access_token),'userid':user.id})
    
    return Response({'status': 'error', 'message': 'Invalid Credentials'})

def clean_name(name):
    # Remove characters that are not letters or numbers
    return re.sub(r'[^a-zA-Z0-9]', '', name.lower())

def generate_username(first_name, last_name):
    first = clean_name(first_name)
    last = clean_name(last_name)

    # Try base variations
    base_variants = [
        f"{first}{last}",
        f"{first}_{last}",
        f"{first}_{last[:1]}",
        f"{first[:1]}_{last}",
        f"{first[:1]}_{last[:1]}"
    ]

    # Try each variant first
    for variant in base_variants:
        if not m.User.objects.filter(username=variant).exists():
            return variant

    # Fallback: add numbers until a unique one is found
    while True:
        variant = f"{first}_{last}_{rd.randint(100, 9999)}"
        if not m.User.objects.filter(username=variant).exists():
            return variant


