from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
import math
from ..models.listing_types_models import Photographers,Caterers,CarRenters,Listing,Decorators,PhotographyPlaces,VideoEditors,GraphicDesigners,Venue,Salons,Parlors
from ..models.listing_models import Packages,AddOns,PicturesListings
from ..models.review_models import Review,ReviewDetails
from ..Serializers.listing_serializers import ListingSerializer,PackagesSerializer,PicturesListingSerializers
from ..Serializers.review_serializers import ReviewSerializer,ReviewDetailsSerializer
from ..Serializers.service_serializers import PhotographersSerializer,CaterersSerializer,CarRentersSerializer,DecoratorsSerializer,PhotographyPlacesSerializer,VideoEditorsSerializer,GraphicDesignersSerializer,VenueSerializer,SalonsSerializer,ParlorsSerializer
from ..models.booking_models import Booking
from ..models.product_models import Product
from ..models.user_models import User
from ..Serializers.listing_serializers import ProductsSerializer
from ..Serializers.service_serializers import AddOnsSerializer

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def photographer_view_page(request, listingid):
    photographer_view = Photographers.objects.get( listingId = listingid)
    listing = Listing.objects.get(id = listingid)
    addons = AddOns.objects.filter(listingId = listingid)
    package = Packages.objects.filter(listingId = listingid)
    review = Review.objects.filter(listingId =listingid)
    pic = PicturesListings.objects.filter(listingId=listingid)
    picture_serializer = PicturesListingSerializers(pic, many=True)
    review_serializer = ReviewSerializer( review, many = True)
    package_serializer = PackagesSerializer( package, many = True)
    addons_serializer = AddOnsSerializer( addons, many = True)
    serializer = PhotographersSerializer( photographer_view, many=False)
    listing_serializer = ListingSerializer (listing, many =False)
    bookings = Booking.objects.filter(
            listing_id=listingid,
            status__in=['confirmed', 'completed']
        )
        
    booked_dates = [booking.booking_date for booking in bookings]
    review_data= ReviewDetails.objects.get(listingId=listingid)
    review_data = ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': addons_serializer.data,'reviewData':review_data.data,
    'Package': package_serializer.data,'Review': review_serializer.data, 'Listing': listing_serializer.data,'pictures':picture_serializer.data,'bookedDates': booked_dates})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def car_renter_view_page(request, listingid):
    listing = Listing.objects.get(id = listingid)
    car_renters = CarRenters.objects.get(listingId = listingid)
    addons = AddOns.objects.filter(listingId = listingid)
    package = Packages.objects.filter(listingId = listingid)
    review = Review.objects.filter(listingId =listingid)
    product = Product.objects.filter(listingId=listingid)
    pic = PicturesListings.objects.filter(listingId=listingid)
    picture_serializer = PicturesListingSerializers(pic, many=True)
    review_serializer = ReviewSerializer( review, many = True)
    package_serializer = PackagesSerializer( package, many = True)
    addons_serializer = AddOnsSerializer( addons, many = True)
    cars = ProductsSerializer(product, many=True)
    serializer = CarRentersSerializer(car_renters, many=False)
    listing_serializer = ListingSerializer (listing, many =False)
    review_data= ReviewDetails.objects.get(listingId=listingid)
    review_data = ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': addons_serializer.data,'reviewData':review_data.data,
                    'products': cars.data,
    'Package': package_serializer.data,'Review': review_serializer.data, 'Listing': listing_serializer.data,'pictures':picture_serializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def graphic_designer_view_page(request, listingid):
    graphicdesignerid = listingid
    listing = Listing.objects.get(id= graphicdesignerid)
    graphic_designers = GraphicDesigners.objects.get(listingId = graphicdesignerid)
    addons = AddOns.objects.filter(listingId = listingid)
    package = Packages.objects.filter(listingId = listingid)
    review = Review.objects.filter(listingId =listingid)
    pic = PicturesListings.objects.filter(listingId=listingid)
    picture_serializer = PicturesListingSerializers(pic, many=True)
    review_serializer = ReviewSerializer( review, many = True)
    package_serializer =PackagesSerializer( package, many = True)
    addons_serializer =AddOnsSerializer( addons, many = True)
    serializer =GraphicDesignersSerializer(graphic_designers,many=False)
    listing_serializer =ListingSerializer (listing, many =False)
    review_data= ReviewDetails.objects.get(listingId=listingid)
    review_data =ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': serializer.data, 'reviewData':review_data.data,'Addons':addons_serializer.data,'Packages':package_serializer.data,  'Listing':listing_serializer.data, 
                    'Package': package_serializer.data, 'Review': review_serializer.data,'pictures':picture_serializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def caterer_view_page(request,listingid):
    caterer_id= listingid
    caterer_view = Caterers.objects.get(listingId = caterer_id)
    listing = Listing.objects.get(id = caterer_id)
    addons = AddOns.objects.filter(listingId =  caterer_id)
    package = Packages.objects.filter(listingId =  caterer_id)
    review = Review.objects.filter(listingId = caterer_id)
    pic = PicturesListings.objects.filter(listingId= caterer_id)
    product = Product.objects.filter(listingId=caterer_id)
    menu =ProductsSerializer(product, many=True)
    picture_serializer =PicturesListingSerializers(pic, many=True)
    review_serializer =ReviewSerializer( review, many = True)
    package_serializer =PackagesSerializer( package, many = True)
    addons_serializer =AddOnsSerializer( addons, many = True)
    serializer =CaterersSerializer( caterer_view, many=False)
    listing_serializer =ListingSerializer (listing, many =False)
    bookings = Booking.objects.filter(
            listing_id=listingid,
            status__in=['confirmed', 'completed'] 
        )
        
    booked_dates = [booking.booking_date for booking in bookings]
    review_data= ReviewDetails.objects.get(listingId=listingid)
    review_data =ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': serializer.data,
    'bookedDates':booked_dates,
    'products':menu.data,
                    'Addons': addons_serializer.data,'reviewData':review_data.data,
    'Package': package_serializer.data,'Review': review_serializer.data, 'Listing': listing_serializer.data,'pictures':picture_serializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def video_editor_view_page(request, videoeditorid):
    listing =Listing.objects.get(id = videoeditorid)
    video_editors = VideoEditors.objects.get(listingId = videoeditorid)
    addons = AddOns.objects.filter(listingId =  videoeditorid)
    package = Packages.objects.filter(listingId =  videoeditorid)
    review = Review.objects.filter(listingId = videoeditorid)
    pic = PicturesListings.objects.filter(listingId= videoeditorid)
    picture_serializer =PicturesListingSerializers(pic, many=True)
    addons_serializer =AddOnsSerializer( addons, many = True)
    video_editors_serializer =VideoEditorsSerializer(video_editors, many =False)
    package_serializer =PackagesSerializer(package, many = True)
    review_serializer =ReviewSerializer(review,many=True)
    listing_serializer =ListingSerializer(listing, many=False)
    review_data= ReviewDetails.objects.get(listingId=videoeditorid)
    review_data =ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': video_editors_serializer.data,'reviewData':review_data.data, 'Addons':addons_serializer.data,  'Listing':listing_serializer.data, 
                     'Package': package_serializer.data, 'Review': review_serializer.data,'pictures':picture_serializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def venue_view_page(request, listingid):
    venue_id = listingid
    listing = Listing.objects.get(id = venue_id)
    venue_view = Venue.objects.get(listingId= venue_id)
    addons = AddOns.objects.filter(listingId = venue_id)
    package = Packages.objects.filter(listingId = venue_id)
    review = Review.objects.filter(listingId =venue_id)
    pic = PicturesListings.objects.filter(listingId=venue_id)
    picture_serializer =PicturesListingSerializers(pic, many=True)
    review_serializer =ReviewSerializer( review, many = True)
    package_serializer =PackagesSerializer( package, many = True)
    bookings = Booking.objects.filter(
            listing_id=listingid,
            status__in=['confirmed', 'completed'] 
        )
        
    booked_dates = [booking.booking_date for booking in bookings]
    addons_serializer =AddOnsSerializer( addons, many = True)
    serializer =VenueSerializer( venue_view, many=False)
    listing_serializer =ListingSerializer (listing, many =False)
    review_data= ReviewDetails.objects.get(listingId=listingid)
    review_data =ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': addons_serializer.data,'reviewData':review_data.data,
    'Package': package_serializer.data,'Review': review_serializer.data, 'Listing': listing_serializer.data,'pictures':picture_serializer.data,'bookedDates':booked_dates})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def salon_view_page(request, listingid):
    salon_view = Salons.objects.get(listingId = listingid)
    listing = Listing.objects.get(id = listingid)
    addons = AddOns.objects.filter(listingId = listingid)
    package = Packages.objects.filter(listingId = listingid)
    review = Review.objects.filter(listingId =listingid)
    pic = PicturesListings.objects.filter(listingId=listingid)
    picture_serializer =PicturesListingSerializers(pic, many=True)
    review_serializer =ReviewSerializer( review, many = True)
    package_serializer =PackagesSerializer( package, many = True)
    addons_serializer =AddOnsSerializer( addons, many = True)
    serializer =SalonsSerializer( salon_view, many=False)
    listing_serializer =ListingSerializer (listing, many =False)
    review_data= ReviewDetails.objects.get(listingId=listingid)
    review_data =ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': addons_serializer.data,'reviewData':review_data.data,
    'Package': package_serializer.data,'Review': review_serializer.data, 'Listing': listing_serializer.data,'pictures':picture_serializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def parlour_view_page(request, listingid):
    parlor_view = Parlors.objects.get(listingId = listingid)
    listing = Listing.objects.get(id = listingid)
    addons = AddOns.objects.filter(listingId = listingid)
    package = Packages.objects.filter(listingId = listingid)
    review = Review.objects.filter(listingId =listingid)
    pic = PicturesListings.objects.filter(listingId=listingid)
    picture_serializer =PicturesListingSerializers(pic, many=True)
    review_serializer =ReviewSerializer( review, many = True)
    package_serializer =PackagesSerializer( package, many = True)
    addons_serializer =AddOnsSerializer( addons, many = True)
    serializer =ParlorsSerializer(parlor_view, many=False)
    listing_serializer =ListingSerializer (listing, many =False)
    review_data= ReviewDetails.objects.get(listingId=listingid)
    review_data =ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': addons_serializer.data,'reviewData':review_data.data,
    'Package': package_serializer.data,'Review': review_serializer.data, 'Listing': listing_serializer.data,'pictures':picture_serializer.data})


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def photography_places_view_page(request, listingid):
    photographer_view = PhotographyPlaces.objects.get( listingId =listingid)
    listing = Listing.objects.get(id = listingid)
    addons = AddOns.objects.filter(listingId = listingid)
    package = Packages.objects.filter(listingId = listingid)
    review = Review.objects.filter(listingId =listingid)
    pic = PicturesListings.objects.filter(listingId=listingid)
    picture_serializer =PicturesListingSerializers(pic, many=True)
    review_serializer =ReviewSerializer( review, many = True)
    package_serializer =PackagesSerializer( package, many = True)
    addons_serializer =AddOnsSerializer( addons, many = True)
    serializer =PhotographyPlacesSerializer( photographer_view, many=False)
    listing_serializer =ListingSerializer (listing, many =False)
    bookings = Booking.objects.filter(
            listing_id=listingid,
            status__in=['confirmed', 'completed'] 
        )
        
    booked_dates = [booking.booking_date for booking in bookings]
    review_data= ReviewDetails.objects.get(listingId=listingid)
    review_data =ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': addons_serializer.data,'reviewData':review_data.data,
    'Package': package_serializer.data,'Review': review_serializer.data, 'Listing': listing_serializer.data,'pictures':picture_serializer.data,'bookedDates':booked_dates})

@api_view(['GET'])
@permission_classes([AllowAny])
def decorator_detail_page(request,listingId):
    listing_details = Listing.objects.get(id=listingId)
    decorator_details = Decorators.objects.get(listingId=listingId)
    addons = AddOns.objects.filter(listingId = listingId)
    package = Packages.objects.filter(listingId = listingId)
    review = Review.objects.filter(listingId =listingId)
    pic = PicturesListings.objects.filter(listingId=listingId)
    product = Product.objects.filter(listingId=listingId)
    items = ProductsSerializer(product, many=True)
    picture_serializer =PicturesListingSerializers(pic, many=True)
    review_serializer =ReviewSerializer( review, many = True)
    package_serializer =PackagesSerializer( package, many = True)
    addons_serializer =AddOnsSerializer( addons, many = True)
    serializer =DecoratorsSerializer( decorator_details, many=False)
    listing_serializer =ListingSerializer (listing_details, many =False)
    review_data= ReviewDetails.objects.get(listingId=listingId)
    review_data =ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': serializer.data,'reviewData':review_data.data,
                    'Addons': addons_serializer.data,'products':items.data,
    'Package': package_serializer.data,'Review': review_serializer.data, 'Listing': listing_serializer.data,'pictures':picture_serializer.data})

@api_view(['POST'])
@permission_classes([AllowAny])
def add_review(request):
    review = request.data.get('review')
    rating = request.data.get('rating')
    listingid = request.data.get('listingId')
    userid = request.data.get('userId')
    listing = Listing.objects.get(id =listingid)
    user = User.objects.get(id = userid)
    review = Review(listingId = listing, userID = user, rating = rating, review = review)
    review.save()
    new_rating = float(listing.rating * listing.ratingCount) + float(rating)
    listing.ratingCount += 1
    listing.rating = new_rating/listing.ratingCount
    listing.save(update_fields=['ratingCount','rating']) 
    rdetails = ReviewDetails.objects.filter(listingId=listing).first()
    rating = math.floor(rating)
    if not rdetails:
        rdetails = ReviewDetails(listingId=listing)
        rdetails.save()
        rdetails = ReviewDetails.objects.filter(listingId=listing).first()
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

def calculate_reviews(data):
    review_data = {
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
            review_data['5'] += 1
        elif value == 4:
            review_data['4'] += 1
        elif value == 3:
            review_data['3'] += 1
        elif value == 2:
            review_data['2'] += 1
        elif value == 1:
            review_data['1'] += 1
    if len(data) != 0:
        review_data['average'] = sum(int(float(data[i]['rating'])) for i in range(len(data)))/len(data)
    else:
        review_data['average'] = 0

    return review_data

