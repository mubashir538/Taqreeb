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
from .. import models as m
from django.utils import timezone
from ..models import UserActivity, Order,Review,User,Review,BusinessOwner,Freelancer,Listing,Payment,Events
from django.utils.timezone import make_aware
from datetime import time, timedelta, date
import datetime
from django.db.models import Avg, Count, Sum
from datetime import datetime, date
from django.utils import timezone
import pytz

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

@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def dashboard_most_used_services(request):
    now = timezone.now()
    data = []
    for month in range(1, 8):  # Jan to July
        count = UserActivity.objects.filter(
            action='service_click',
            timestamp__year=now.year,
            timestamp__month=month
        ).count()
        month_name = date(1900, month, 1).strftime('%b')  # Corrected
        data.append({'month': month_name, 'count': count})

    return Response({'status': 'success', 'data': data})

@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def dashboard_top_categories(request):
    activities = UserActivity.objects.filter(action='category_click')
    category_counts = {}

    for activity in activities:
        cat_name = activity.metadata.get('category', 'Unknown')
        category_counts[cat_name] = category_counts.get(cat_name, 0) + 1

    top_categories = sorted(
        [{'name': k, 'value': v} for k, v in category_counts.items()],
        key=lambda x: x['value'],
        reverse=True
    )[:4]

    return Response({'status': 'success', 'data': top_categories})


@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def dashboard_recent_activity(request):
    # Get current time in UTC
    now = timezone.now()
    today_start = now.replace(hour=0, minute=0, second=0, microsecond=0)
    today_end = now.replace(hour=23, minute=59, second=59, microsecond=999999)

    # Define Pakistan timezone
    pakistan_timezone = pytz.timezone('Asia/Karachi')

    orders = Order.objects.filter(created_at__gte=today_start, created_at__lte=today_end)
    reviews = Review.objects.filter(date__gte=today_start, date__lte=today_end)
    users = User.objects.filter(date_joined__gte=today_start, date_joined__lte=today_end)

    activities = []

    for order in orders:
        user_name = f"{order.user.firstName} {order.user.lastName}"
        # Convert order.created_at to Pakistan time
        local_time = order.created_at.astimezone(pakistan_timezone)
        time_formatted = local_time.strftime('%I:%M %p')
        activities.append({
            'timestamp': local_time,
            'description': f"User {user_name} placed a new order of amount ${order.total_amount} at {time_formatted}"
        })

    for review in reviews:
        user_name = f"{review.userID.firstName} {review.userID.lastName}"
        # Convert review.date to Pakistan time
        local_time = review.date.astimezone(pakistan_timezone)
        time_formatted = local_time.strftime('%I:%M %p')
        activities.append({
            'timestamp': local_time,
            'description': f"User {user_name} posted a review: \"{review.review}\" at {time_formatted}"
        })

    for user in users:
        full_name = f"{user.firstName} {user.lastName}"
        # Convert user.date_joined to Pakistan time
        local_time = user.date_joined.astimezone(pakistan_timezone)
        time_formatted = local_time.strftime('%I:%M %p')
        activities.append({
            'timestamp': local_time,
            'description': f"New user registered: {full_name} at {time_formatted}"
        })

    activities_sorted = sorted(activities, key=lambda x: x['timestamp'], reverse=True)

    final_data = [activity['description'] for activity in activities_sorted[:10]]

    return Response({'status': 'success', 'data': final_data})

@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def dashboard_top_search_terms(request):
    now = timezone.now()
    start_of_month = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)

    search_activities = UserActivity.objects.filter(
        action='search',
        timestamp__gte=start_of_month,
        timestamp__lte=now
    )

    search_counts = {}

    for activity in search_activities:
        search_query = activity.metadata.get('search_query', '').lower()
        if search_query:
            search_counts[search_query] = search_counts.get(search_query, 0) + 1

    sorted_terms = sorted(search_counts.items(), key=lambda x: x[1], reverse=True)[:10]
    data = [{'term': term, 'count': count} for term, count in sorted_terms]

    return Response({'status': 'success', 'data': data})


@api_view(['GET']) 
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def dashboard_most_searched(request):
    today = timezone.now().date()
    days = [today - timedelta(days=i) for i in range(6, -1, -1)]  # Past 7 days
    counts = []

    for day in days:
        start_datetime = make_aware(datetime.combine(day, time.min))
        end_datetime = make_aware(datetime.combine(day, time.max))


        count = UserActivity.objects.filter(
            action='search',
            timestamp__range=(start_datetime, end_datetime)
        ).count()

        counts.append({'day': day.strftime('%a'), 'count': count})

    return Response({'status': 'success', 'data': counts})

@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def dashboard_statistics(request):
    now = timezone.now()
    today_start = now.replace(hour=0, minute=0, second=0, microsecond=0)

    daily_active_users = UserActivity.objects.filter(timestamp__gte=today_start).values('user').distinct().count()
    searches_today = UserActivity.objects.filter(action='search', timestamp__gte=today_start).count()
    new_users_today = User.objects.filter(date_joined__gte=today_start).count()
    average_session_time = 25  # Hardcoded for now
    total_users = User.objects.count()
    total_events = Events.objects.count()
    total_vendors = BusinessOwner.objects.count() + Freelancer.objects.count()
    total_revenue = Payment.objects.filter(status='completed').aggregate(Sum('amount'))['amount__sum'] or 0
    active_services = Listing.objects.filter(status='active').count()
    satisfaction_rate = Review.objects.aggregate(Avg('rating'))['rating__avg'] or 0
    satisfaction_rate = round((satisfaction_rate / 5) * 100)

    return Response({
        'userStats': {
            'dailyActiveUsers': daily_active_users,
            'searchesToday': searches_today,
            'newUsersToday': new_users_today,
            'averageSessionTime': f"{average_session_time}m",
            'totalUsers': total_users,
        },
        'eventStats': {
            'totalEvents': total_events
        },
        'vendorStats': {
            'totalVendors': total_vendors,
            'totalRevenue': f"${int(total_revenue/1000)}K" if total_revenue else "$0",
            'activeServices': active_services,
            'satisfactionRate': f"{satisfaction_rate}%",
        }
    })