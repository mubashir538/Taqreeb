from .. import models as md
from .. import Serializers as s
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated,AllowAny
from rest_framework.response import Response
from myapp.models import UserActivity
from django.utils.timezone import now
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import authenticate
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from django.contrib.auth import get_user_model
from django.contrib.auth.hashers import check_password
from rest_framework_simplejwt.views import TokenRefreshView
from rest_framework.response import Response
from rest_framework import status
from ..utils.react_jwt import ReactToken

# @csrf_exempt
# def react_login_view(request):
#     if request.method == 'POST':
#         data = json.loads(request.body)
#         email = data.get('email').strip() 
#         password = data.get('password').strip()

#         try:
#             user = md.ReactUser.objects.get(email=email)
            
#             if password == user.password:
#                 refresh = ReactToken.for_react_user(user)
                
#                 return JsonResponse({
#                     'success': True,
#                     'message': 'Login successful',
#                     'tokens': {
#                         'access': str(refresh.access_token),
#                         'refresh': str(refresh)
#                     },
#                     'user': {
#                         'email': user.email,
#                         'id': user.id,
#                         'username': user.username
#                     }
#                 })
#             else:
#                 return JsonResponse({'success': False, 'message': 'Invalid password'}, status=401)
#         except md.ReactUser.DoesNotExist:
#             return JsonResponse({'success': False, 'message': 'Email not found'}, status=404)
    
#     return JsonResponse({'error': 'POST request required'}, status=400)

# class ReactTokenRefreshView(TokenRefreshView):
#     def post(self, request, *args, **kwargs):
#         serializer = self.get_serializer(data=request.data)

#         try:
#             serializer.is_valid(raise_exception=True)
#         except Exception as e:
#             return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

#         try:
#             # Get the original refresh token to check app type
#             from rest_framework_simplejwt.tokens import RefreshToken
#             old_refresh = RefreshToken(request.data['refresh'])
            
#             if old_refresh.get('app_type') != 'react':
#                 return Response({'error': 'Invalid token type'}, status=status.HTTP_401_UNAUTHORIZED)
                
#             # Get the React user
#             user = ReactUser.objects.get(id=old_refresh.get('react_user_id'))
            
#             # Generate new tokens
#             refresh = ReactToken.for_react_user(user)
            
#             return Response({
#                 'access': str(refresh.access_token),
#                 'refresh': str(refresh)
#             })
            
#         except Exception as e:
#             return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

# class ReactUserRegisterView(APIView):
#     def post(self, request):
#         serializer = s.ReactUserRegisterSerializer(data=request.data)
#         if serializer.is_valid():
#             user = serializer.save()
#             refresh = RefreshToken.for_user(user)  # this won't work unless we use Django User
#             return Response({'message': 'User created'}, status=status.HTTP_201_CREATED)
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# class ReactUserLoginView(APIView):
#     def post(self, request):
#         serializer = s.ReactUserLoginSerializer(data=request.data)
#         if serializer.is_valid():
#             username = serializer.validated_data['username']
#             password = serializer.validated_data['password']
#             try:
#                 user = md.ReactUser.objects.get(username=username)
#             except md.ReactUser.DoesNotExist:
#                 return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

#             if user.check_password(password):
#                 # You need to manually create JWT token (or return a dummy token for now)
#                 return Response({'message': 'Login successful'}, status=status.HTTP_200_OK)
#             return Response({'error': 'Invalid password'}, status=status.HTTP_401_UNAUTHORIZED)
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_event_dashboard_data(request):
    from django.db.models import Count

    events = md.Events.objects.all().order_by('-id')
    submitted_requests = events[:3]
    recent_requests = events[:2]  # You can customize

    submitted_serialized = [
        {
            "name": e.name,
            "user": e.userID.firstName if e.userID else "Unknown",
            "date": e.date,
            "status": "Pending"  # Or infer from real logic if you have a field
        }
        for e in submitted_requests
    ]

    recent_serialized = [
        {
            "name": e.name,
            "user": e.userID.firstName if e.userID else "Unknown",
            "status": "Approved"  # Fake status for demo
        }
        for e in recent_requests
    ]

    suggested_plans = [
        {"name": "Outdoor Summer Party", "for": "Birthday Celebration", "status": "New"},
        {"name": "Conference Room Setup", "for": "Corporate Meeting", "status": "New"},
        {"name": "Romantic Dinner", "for": "Wedding Anniversary", "status": "Modified"},
    ]

    statistics = {
        "total": events.count(),
        "approved": 198,
        "pending": 28,
        "rejected": 28
    }

    return Response({
        "submitted_requests": submitted_serialized,
        "recent_requests": recent_serialized,
        "suggested_plans": suggested_plans,
        "statistics": statistics
    })

