from rest_framework.response import Response
from .. import models as m
from rest_framework.decorators import api_view, permission_classes
from .. import Serializers as s
from rest_framework.permissions import IsAuthenticated

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def getWishlist(request,uid):
    uid = m.User.objects.get(id=uid)
    list = m.Wishlist.objects.filter(user=uid)
    list = m.Listing.objects.filter(id__in=list.values_list('listing', flat=True))
    ListingSerializer = s.ListingSerializer(list, many=True)
    Pictures = []
    Listings = ListingSerializer.data[:]
    for i in Listings:
        pic = m.PicturesListings.objects.filter(listingId=i['id'])
        serializer = s.PicturesListingSerializers(pic, many=True)
        Pictures.append(serializer.data)
    return Response({'status':'success', 'list':Listings, 'pictures':Pictures})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def checkWishlist(request):
    userid = request.query_params.get('userid')
    listing_id = request.query_params.get('listing')
    
    try:
        exists = m.Wishlist.objects.filter(
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
def addtoWishlist(request):
    userid = request.data.get('userid')
    listing = request.data.get('listing')
    listing = m.Listing.objects.get(id=listing)
    userid = m.User.objects.get(id=userid)
    m.Wishlist(user=userid,listing=listing).save()
    return Response({'status':'success'}) 

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def removeFromWishlist(request):
    userid = request.data.get('userid')
    listing = request.data.get('listing')
    listing = m.Listing.objects.get(id=listing)
    userid = m.User.objects.get(id=userid)
    m.Wishlist.objects.filter(user=userid,listing=listing).delete()
    return Response({'status':'success'}) 