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
from .. import models2 as m
from ..models2 import UserActivity, Order,Review,User,Review,BusinessOwner,Freelancer,Listing,Payment,Events
from django.utils.timezone import make_aware
from datetime import time, timedelta, date
import datetime
from django.db.models import Avg, Count, Sum
from datetime import datetime, date
from django.utils import timezone
import pytz
from django.core.paginator import Paginator,EmptyPage
from ..Serializers import ListingSerializer,VenueSerializer,CaterersSerializer,PackagesSerializer,ProductsSerializer,AddOnsSerializer,PicturesListingSerializers
from ..models2 import Venue,Caterers,Packages,Product,AddOns,PicturesListings
from django.db.models import Q

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

@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def pending_approvals_stats(request):
    # Count all pending listings
    total_pending = Listing.objects.filter(status='pending').count()
    
    # Count by category/type
    pending_by_type = Listing.objects.filter(status='pending').values('type').annotate(count=Count('id'))
    
    # Recent pending (last 7 days)
    week_ago = timezone.now() - timezone.timedelta(days=7)
    recent_pending = Listing.objects.filter(
        status='pending', 
        created_at__gte=week_ago
    ).count()
    
    # Oldest pending (older than 30 days)
    month_ago = timezone.now() - timezone.timedelta(days=30)
    oldest_pending = Listing.objects.filter(
        status='pending', 
        created_at__lte=month_ago
    ).count()
    
    return Response({
        'pendingStats': {
            'totalPending': total_pending,
            'pendingByType': {item['type']: item['count'] for item in pending_by_type},
            'recentPending': recent_pending,
            'oldestPending': oldest_pending,
        }
    })

@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def pending_listings(request):
    # Get query parameters
    listing_type = request.query_params.get('type', None)
    search_query = request.query_params.get('search', None)
    page = int(request.query_params.get('page', 1))
    page_size = int(request.query_params.get('page_size', 10))
    
    # Base queryset
    queryset = Listing.objects.filter(status='pending').select_related('ownerID', 'freelancerID')
    
    # Apply filters
    if listing_type:
        queryset = queryset.filter(type=listing_type)
    
    if search_query:
        queryset = queryset.filter(
            Q(name__icontains=search_query) |
            Q(description__icontains=search_query) |
            Q(location__icontains=search_query)
        )
    
    # Pagination
    paginator = Paginator(queryset, page_size)
    try:
        listings = paginator.page(page)
    except EmptyPage:
        listings = paginator.page(paginator.num_pages)
    
    serializer = ListingSerializer(listings, many=True)
    
    return Response({
        'listings': serializer.data,
        'pagination': {
            'total': paginator.count,
            'page': page,
            'page_size': page_size,
            'total_pages': paginator.num_pages,
        }
    })

@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def pending_listing_detail(request, pk):
    try:
        listing = Listing.objects.get(pk=pk, status='pending')
    except Listing.DoesNotExist:
        return Response({'error': 'Listing not found'}, status=404)
    
    # Get the base listing data
    listing_serializer = ListingSerializer(listing)
    
    # Get service-specific details based on type
    service_details = None
    if listing.type == 'Venue':
        service_details = Venue.objects.filter(listingID=listing).first()
    elif listing.type == 'Caterers':
        service_details = Caterers.objects.filter(listingId=listing).first()
    # Add other service types...
    
    # Serialize service details if they exist
    service_serializer = None
    if service_details:
        if listing.type == 'Venue':
            service_serializer = VenueSerializer(service_details)
        elif listing.type == 'Caterers':
            service_serializer = CaterersSerializer(service_details)
        # Add other serializers...
    
    # Get packages and products
    packages = Packages.objects.filter(listingId=listing)
    products = Product.objects.filter(listingId=listing)
    
    return Response({
        'listing': listing_serializer.data,
        'serviceDetails': service_serializer.data if service_serializer else None,
        'packages': PackagesSerializer(packages, many=True).data,
        'products': ProductsSerializer(products, many=True).data,
        'addOns': AddOnsSerializer(AddOns.objects.filter(listingId=listing), many=True).data,
        'images': PicturesListingSerializers(
            PicturesListings.objects.filter(listingId=listing), 
            many=True
        ).data,
    })

@api_view(['POST'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def update_listing_status(request, pk):
    try:
        listing = Listing.objects.get(pk=pk, status='pending')
    except Listing.DoesNotExist:
        return Response({'error': 'Listing not found'}, status=404)
    
    new_status = request.data.get('status')
    if new_status not in ['active', 'rejected']:
        return Response({'error': 'Invalid status'}, status=400)
    
    # Update status
    listing.status = new_status
    listing.save()
    
    # If approved, you might want to do additional actions here
    if new_status == 'active':
        # Example: Send notification to owner
        pass
    
    return Response({
        'success': True,
        'message': f'Listing status updated to {new_status}',
        'newStatus': new_status
    })

@api_view(['POST'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def bulk_update_listing_status(request):
    listing_ids = request.data.get('ids', [])
    new_status = request.data.get('status')
    
    if not listing_ids:
        return Response({'error': 'No listings selected'}, status=400)
    
    if new_status not in ['active', 'rejected']:
        return Response({'error': 'Invalid status'}, status=400)
    
    # Update all listings
    updated = Listing.objects.filter(
        pk__in=listing_ids,
        status='pending'
    ).update(status=new_status)
    
    return Response({
        'success': True,
        'message': f'Updated {updated} listings to {new_status}',
        'count': updated
    })