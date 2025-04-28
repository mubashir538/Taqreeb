from rest_framework.decorators import api_view, permission_classes,authentication_classes
from .react_authentication import ReactJWTAuthentication
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from .react_authentication import ReactTokenObtainPairSerializer
from .react_models import ReactUser
from .react_permission import IsReactUser
from .react_serializer import ReactUserSerializer, ReactUserCreateSerializer
from django.contrib.auth.hashers import check_password
from rest_framework import status

@api_view(['POST'])
@permission_classes([AllowAny])
def ReactUserLogin(request):
    email = request.data.get('email')
    password = request.data.get('password')
    
    user = ReactUser.objects.filter(email=email).first()
    
    if user and check_password(password, user.password):
        refresh = ReactTokenObtainPairSerializer.get_token(user)
        return Response({
            'status': 'success',
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'user': ReactUserSerializer(user).data
        })
    
    return Response({'status': 'error', 'message': 'Invalid credentials'}, status=400)


@api_view(['POST'])
@permission_classes([AllowAny])
def create_react_user(request):
    serializer = ReactUserCreateSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response({
            'status': 'success',
            'message': 'React user created successfully',
            'user': serializer.data
        }, status=status.HTTP_201_CREATED)
    return Response({
        'status': 'error',
        'message': 'Invalid data',
        'errors': serializer.errors
    }, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def react_user_profile(request):
    """
    Test endpoint to verify React user authentication
    Returns user data if properly authenticated
    """
    try:
        # Verify this is a ReactUser (not regular User)
        if not isinstance(request.user, ReactUser):
            return Response(
                {"error": "Invalid user type - ReactUser required"},
                status=403
            )
        print('Authentication successful')
        serializer = ReactUserSerializer(request.user)
        
        return Response({
            "status": "success",
            "message": "You are properly authenticated as a React user",
            "user": serializer.data,
            "auth_headers": {
                "used_authorization": request.headers.get('Authorization'),
            }
        })
    except Exception as e:
        return Response(
            {"error": str(e)},
            status=500
        )