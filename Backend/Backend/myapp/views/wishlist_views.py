from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from ..models.user_models import User
from ..models.listing_models import Wishlist, Listing,PicturesListings
from ..Serializers.listing_serializers import ListingSerializer, PicturesListingSerializers
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_wishlist(request,uid):
    uid = User.objects.get(id=uid)
    get_wishlist_list = Wishlist.objects.filter(user=uid)
    get_wishlist_list = Listing.objects.filter(id__in=get_wishlist_list.values_list('listing', flat=True))
    listing_serializer = ListingSerializer(get_wishlist_list, many=True)
    pictures = []
    listings = listing_serializer.data[:]
    for i in listings:
        pic = PicturesListings.objects.filter(listingId=i['id'])
        serializer = PicturesListingSerializers(pic, many=True)
        pictures.append(serializer.data)
    return Response({'status':'success', 'list':listings, 'pictures':pictures})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def check_wishlist(request):
    userid = request.query_params.get('userid')
    listing_id = request.query_params.get('listing')
    
    try:
        exists = Wishlist.objects.filter(
            user_id=userid, 
            listing_id=listing_id
        ).exists()
        
        return Response({
            'status': 'success',
            'is_in_wishlist': exists
        })
        
    except Exception as e:
        return Response({
            'status': 'error',
            'message': str(e)
        }, status=400)
    
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_to_wishlist(request):
    userid = request.data.get('userid')
    listing = request.data.get('listing')
    listing = Listing.objects.get(id=listing)
    userid = User.objects.get(id=userid)
    Wishlist(user=userid,listing=listing).save()
    return Response({'status':'success'}) 

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def remove_from_wishlist(request):
    userid = request.data.get('userid')
    listing = request.data.get('listing')
    listing = Listing.objects.get(id=listing)
    userid = User.objects.get(id=userid)
    Wishlist.objects.filter(user=userid,listing=listing).delete()
    return Response({'status':'success'}) 