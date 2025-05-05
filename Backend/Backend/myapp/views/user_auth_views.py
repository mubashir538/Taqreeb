from django.utils.timezone import now
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from firebase_admin import credentials, firestore, initialize_app, messaging
import os
import bcrypt
from ..models import UserActivity
from .. import models as m
import random as rd
from django.conf import settings
from .helper_methods import generate_username
from django.core.files.storage import FileSystemStorage
from rest_framework_simplejwt.tokens import RefreshToken
from django.core.mail import send_mail

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
    username = generate_username(firstName,lastName)
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
    UserActivity.objects.create(
        user=user,
        action='user_register',
        metadata={
            'firstName': user.firstName,
            'lastName': user.lastName,
            'email': user.email,
            'city': user.city,
            'gender': user.gender,
        },
        timestamp=now()
    )

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
            token=contactNumber,
        )

    response = messaging.send(message)
    print(response)
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
        username = generate_username(firstName,lastName)
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