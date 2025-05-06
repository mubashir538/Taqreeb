# from rest_framework.decorators import api_view, permission_classes
# from rest_framework.response import Response
# from rest_framework.permissions import IsAuthenticated
# from .. import models as md
# from .. import Serializers as s
# from django.utils.timezone import now, timedelta

# @api_view(['GET'])
# @permission_classes([IsAuthenticated])
# def get_all_categories(request):
#     categories = md.Categories.objects.all()
#     serializer = s.CategoriesSerializer(categories, many=True)
#     return Response({'status': 'success', 'categories': serializer.data})


# @api_view(['GET'])
# @permission_classes([IsAuthenticated])
# def get_home_listings(request):
#     listings = md.Listing.objects.all()
#     serializer = s.ListingSerializer(listings, many=True)
#     return Response({'status': 'success', 'listings': serializer.data})


# @api_view(['GET'])
# @permission_classes([IsAuthenticated])
# def get_user_activities(request):
#     recent = md.UserActivity.objects.filter(timestamp__gte=now() - timedelta(days=7))
#     serializer = s.UserActivitySerializer(recent, many=True)
#     return Response({'status': 'success', 'activities': serializer.data})