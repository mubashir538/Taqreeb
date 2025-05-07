from rest_framework.response import Response
from .. import models2 as m
from rest_framework.decorators import api_view, permission_classes
from .. import Serializers as s
from rest_framework.permissions import IsAuthenticated, AllowAny
import math

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def PhotographerViewPage(request, listingid):
    PhotographerView = m.Photographers.objects.get( listingId = listingid)
    Listing = m.Listing.objects.get(id = listingid)
    Addons = m.AddOns.objects.filter(listingId = listingid)
    Package = m.Packages.objects.filter(listingId = listingid)
    Review = m.Review.objects.filter(listingID =listingid)
    pic = m.PicturesListings.objects.filter(listingId=listingid)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.PhotographersSerializer( PhotographerView, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    bookings = m.Booking.objects.filter(
            listing_id=listingid,
            status__in=['confirmed', 'completed']
        )
        
    booked_dates = [booking.booking_date for booking in bookings]
    reviewData= m.ReviewDetails.objects.get(listingID=listingid)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': Addonsserializer.data,'reviewData':reviewData.data,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data,'bookedDates': booked_dates})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def CarRenterViewPage(request, listingid):
    Listing = m.Listing.objects.get(id = listingid)
    CarRenters = m.CarRenters.objects.get(listingID = listingid)
    Addons = m.AddOns.objects.filter(listingId = listingid)
    Package = m.Packages.objects.filter(listingId = listingid)
    Review = m.Review.objects.filter(listingID =listingid)
    product = m.Product.objects.filter(listingId=listingid)
    pic = m.PicturesListings.objects.filter(listingId=listingid)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    cars = s.ProductsSerializer(product, many=True)
    serializer = s.CarRentersSerializer(CarRenters, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    reviewData= m.ReviewDetails.objects.get(listingID=listingid)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': Addonsserializer.data,'reviewData':reviewData.data,
                    'cars': cars.data,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def GraphicDesignerViewPage(request, listingid):
    graphicdesignerid = listingid
    Listing = m.Listing.objects.get(id= graphicdesignerid)
    GraphicDesigners = m.GraphicDesigners.objects.get(listingId = graphicdesignerid)
    Addons = m.AddOns.objects.filter(listingId = listingid)
    Package = m.Packages.objects.filter(listingId = listingid)
    Review = m.Review.objects.filter(listingID =listingid)
    pic = m.PicturesListings.objects.filter(listingId=listingid)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.GraphicDesignersSerializer(GraphicDesigners,many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    reviewData= m.ReviewDetails.objects.get(listingID=listingid)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': serializer.data, 'reviewData':reviewData.data,'Addons':Addonsserializer.data,'Packages':Packageserializer.data,  'Listing':Listingserializer.data, 
                    'Package': Packageserializer.data, 'Review': Reviewserializer.data,'pictures':pictureSerializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def CatererViewPage(request,listingid):
    CatererID= listingid
    CatererView = m.Caterers.objects.get(listingId = CatererID)
    Listing = m.Listing.objects.get(id = CatererID)
    Addons = m.AddOns.objects.filter(listingId =  CatererID)
    Package = m.Packages.objects.filter(listingId =  CatererID)
    Review = m.Review.objects.filter(listingID = CatererID)
    pic = m.PicturesListings.objects.filter(listingId= CatererID)
    product = m.Product.objects.filter(listingId=CatererID)
    menu = s.ProductsSerializer(product, many=True)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.CaterersSerializer( CatererView, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    bookings = m.Booking.objects.filter(
            listing_id=listingid,
            status__in=['confirmed', 'completed'] 
        )
        
    booked_dates = [booking.booking_date for booking in bookings]
    reviewData= m.ReviewDetails.objects.get(listingID=listingid)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': serializer.data,
    'bookedDates':booked_dates,
    'menu':menu.data,
                    'Addons': Addonsserializer.data,'reviewData':reviewData.data,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def VideoEditorViewPage(request, VideoEditorID):
    Listing =m.Listing.objects.get(id = VideoEditorID)
    VideoEditors = m.VideoEditors.objects.get(listingId = VideoEditorID)
    Addons = m.AddOns.objects.filter(listingId =  VideoEditorID)
    Package = m.Packages.objects.filter(listingId =  VideoEditorID)
    Review = m.Review.objects.filter(listingId = VideoEditorID)
    pic = m.PicturesListings.objects.filter(listingId= VideoEditorID)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    VideoEditorsSerializer = s.VideoEditorsSerializer(VideoEditors, many =False)
    PackageSerializer = s.PackagesSerializer(Package, many = True)
    ReviewSerializer = s.ReviewSerializer(Review,many=True)
    ListingSerializer = s.ListingSerializer(Listing, many=False)
    reviewData= m.ReviewDetails.objects.get(listingID=VideoEditorID)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': VideoEditorsSerializer.data,'reviewData':reviewData.data, 'Addons':Addonsserializer.data,  'Listing':ListingSerializer.data, 
                     'Package': PackageSerializer.data, 'Review': ReviewSerializer.data,'pictures':pictureSerializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def VenueViewPage(request, listingid):
    venueId = listingid
    Listing = m.Listing.objects.get(id = venueId)
    VenueView = m.Venue.objects.get(listingID= venueId)
    Addons = m.AddOns.objects.filter(listingId = venueId)
    Package = m.Packages.objects.filter(listingId = venueId)
    Review = m.Review.objects.filter(listingID =venueId)
    pic = m.PicturesListings.objects.filter(listingId=venueId)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    bookings = m.Booking.objects.filter(
            listing_id=listingid,
            status__in=['confirmed', 'completed'] 
        )
        
    booked_dates = [booking.booking_date for booking in bookings]
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.VenueSerializer( VenueView, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    reviewData= m.ReviewDetails.objects.get(listingID=listingid)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': Addonsserializer.data,'reviewData':reviewData.data,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data,'bookedDates':booked_dates})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def SalonViewPage(request, listingid):
    salonView = m.Salons.objects.get(listingId = listingid)
    Listing = m.Listing.objects.get(id = listingid)
    Addons = m.AddOns.objects.filter(listingId = listingid)
    Package = m.Packages.objects.filter(listingId = listingid)
    Review = m.Review.objects.filter(listingID =listingid)
    pic = m.PicturesListings.objects.filter(listingId=listingid)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.SalonsSerializer( salonView, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    reviewData= m.ReviewDetails.objects.get(listingID=listingid)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': Addonsserializer.data,'reviewData':reviewData.data,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def ParlourViewPage(request, listingid):
    parlorView = m.Parlors.objects.get(listingId = listingid)
    Listing = m.Listing.objects.get(id = listingid)
    Addons = m.AddOns.objects.filter(listingId = listingid)
    Package = m.Packages.objects.filter(listingId = listingid)
    Review = m.Review.objects.filter(listingID =listingid)
    pic = m.PicturesListings.objects.filter(listingId=listingid)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.ParlorsSerializer(parlorView, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    reviewData= m.ReviewDetails.objects.get(listingID=listingid)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': Addonsserializer.data,'reviewData':reviewData.data,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data})


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def PhotographyPlacesViewPage(request, listingid):
    PhotographerView = m.PhotographyPlaces.objects.get( listingID =listingid)
    Listing = m.Listing.objects.get(id = listingid)
    Addons = m.AddOns.objects.filter(listingId = listingid)
    Package = m.Packages.objects.filter(listingId = listingid)
    Review = m.Review.objects.filter(listingID =listingid)
    pic = m.PicturesListings.objects.filter(listingId=listingid)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.PhotographyPlacesSerializer( PhotographerView, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    bookings = m.Booking.objects.filter(
            listing_id=listingid,
            status__in=['confirmed', 'completed'] 
        )
        
    booked_dates = [booking.booking_date for booking in bookings]
    reviewData= m.ReviewDetails.objects.get(listingID=listingid)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': Addonsserializer.data,'reviewData':reviewData.data,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data,'bookedDates':booked_dates})

@api_view(['GET'])
@permission_classes([AllowAny])
def DecoratorDetailPage(request,listingId):
    listingDetails = m.Listing.objects.get(id=listingId)
    decoratorDetails = m.Decorators.objects.get(listingId=listingId)
    Addons = m.AddOns.objects.filter(listingId = listingId)
    Package = m.Packages.objects.filter(listingId = listingId)
    Review = m.Review.objects.filter(listingID =listingId)
    pic = m.PicturesListings.objects.filter(listingId=listingId)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.DecoratorsSerializer( decoratorDetails, many=False)
    Listingserializer = s.ListingSerializer (listingDetails, many =False)
    reviewData= m.ReviewDetails.objects.get(listingID=listingId)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': serializer.data,'reviewData':reviewData.data,
                    'Addons': Addonsserializer.data,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data})

@api_view(['POST'])
@permission_classes([AllowAny])
def AddReview(request):
    review = request.data.get('review')
    rating = request.data.get('rating')
    listingId = request.data.get('listingId')
    userId = request.data.get('userId')
    listing = m.Listing.objects.get(id =listingId)
    user = m.User.objects.get(id = userId)
    Review = m.Review(listingID = listing, userID = user, rating = rating, review = review)
    Review.save()
    newRating = float(listing.rating * listing.ratingCount) + float(rating)
    listing.ratingCount += 1
    listing.rating = newRating/listing.ratingCount
    listing.save(update_fields=['ratingCount','rating']) 
    rdetails = m.ReviewDetails.objects.filter(listingID=listing).first()
    rating = math.floor(rating)
    if not rdetails:
        rdetails = m.ReviewDetails(listingID=listing)
        rdetails.save()
        rdetails = m.ReviewDetails.objects.filter(listingID=listing).first()
    if rating == 5:
        rdetails.s5+=1
        rdetails.save(update_fields=['s5'])
    elif rating == 4:
        rdetails.s4+=1
        rdetails.save(update_fields=['s4'])
    elif rating == 3:
        rdetails.s3+=1
        rdetails.save(update_fields=['s3'])
    elif rating == 2:
        rdetails.s2+=1
        rdetails.save(update_fields=['s2'])
    elif rating == 1:
        rdetails.s1+=1
        rdetails.save(update_fields=['s1'])
    return Response({'status': 'success'})

def CalculateReviews(data):
    reviewData = {
        'count' : len(data),
        '5': 0,
        '4': 0,
        '3': 0,
        '2': 0,
        '1': 0,
        'average':0
    }
    for i in data:
        value = int(float(i['rating']))
        if value == 5:
            reviewData['5'] += 1
        elif value == 4:
            reviewData['4'] += 1
        elif value == 3:
            reviewData['3'] += 1
        elif value == 2:
            reviewData['2'] += 1
        elif value == 1:
            reviewData['1'] += 1
    if len(data) != 0:
        reviewData['average'] = sum(int(float(data[i]['rating'])) for i in range(len(data)))/len(data)
    else:
        reviewData['average'] = 0

    return reviewData

