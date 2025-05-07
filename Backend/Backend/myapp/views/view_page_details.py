from rest_framework.response import Response
from .. import models as m
from rest_framework.decorators import api_view, permission_classes
from .. import Serializers as s
from rest_framework.permissions import IsAuthenticated, AllowAny
import math

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def photographer_view_page(request, listingid):
    photographer_view = m.Photographers.objects.get( listingId = listingid)
    listing = m.Listing.objects.get(id = listingid)
    addons = m.AddOns.objects.filter(listingId = listingid)
    package = m.Packages.objects.filter(listingId = listingid)
    review = m.Review.objects.filter(listingID =listingid)
    pic = m.PicturesListings.objects.filter(listingId=listingid)
    picture_serializer = s.PicturesListingSerializers(pic, many=True)
    review_serializer = s.ReviewSerializer( review, many = True)
    package_serializer = s.PackagesSerializer( package, many = True)
    addons_serializer = s.AddOnsSerializer( addons, many = True)
    serializer = s.PhotographersSerializer( photographer_view, many=False)
    listing_serializer = s.ListingSerializer (listing, many =False)
    bookings = m.Booking.objects.filter(
            listing_id=listingid,
            status__in=['confirmed', 'completed']
        )
        
    booked_dates = [booking.booking_date for booking in bookings]
    review_data= m.ReviewDetails.objects.get(listingID=listingid)
    review_data = s.ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': addons_serializer.data,'reviewData':review_data.data,
    'Package': package_serializer.data,'Review': review_serializer.data, 'Listing': listing_serializer.data,'pictures':picture_serializer.data,'bookedDates': booked_dates})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def car_renter_view_page(request, listingid):
    listing = m.Listing.objects.get(id = listingid)
    car_renters = m.CarRenters.objects.get(listingID = listingid)
    addons = m.AddOns.objects.filter(listingId = listingid)
    package = m.Packages.objects.filter(listingId = listingid)
    review = m.Review.objects.filter(listingID =listingid)
    product = m.Product.objects.filter(listingId=listingid)
    pic = m.PicturesListings.objects.filter(listingId=listingid)
    picture_serializer = s.PicturesListingSerializers(pic, many=True)
    review_serializer = s.ReviewSerializer( review, many = True)
    package_serializer = s.PackagesSerializer( package, many = True)
    addons_serializer = s.AddOnsSerializer( addons, many = True)
    cars = s.ProductsSerializer(product, many=True)
    serializer = s.CarRentersSerializer(car_renters, many=False)
    listing_serializer = s.ListingSerializer (listing, many =False)
    review_data= m.ReviewDetails.objects.get(listingID=listingid)
    review_data = s.ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': addons_serializer.data,'reviewData':review_data.data,
                    'cars': cars.data,
    'Package': package_serializer.data,'Review': review_serializer.data, 'Listing': listing_serializer.data,'pictures':picture_serializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def graphic_designer_view_page(request, listingid):
    graphicdesignerid = listingid
    listing = m.Listing.objects.get(id= graphicdesignerid)
    graphic_designers = m.GraphicDesigners.objects.get(listingId = graphicdesignerid)
    addons = m.AddOns.objects.filter(listingId = listingid)
    package = m.Packages.objects.filter(listingId = listingid)
    review = m.Review.objects.filter(listingID =listingid)
    pic = m.PicturesListings.objects.filter(listingId=listingid)
    picture_serializer = s.PicturesListingSerializers(pic, many=True)
    review_serializer = s.ReviewSerializer( review, many = True)
    package_serializer = s.PackagesSerializer( package, many = True)
    addons_serializer = s.AddOnsSerializer( addons, many = True)
    serializer = s.GraphicDesignersSerializer(graphic_designers,many=False)
    listing_serializer = s.ListingSerializer (listing, many =False)
    review_data= m.ReviewDetails.objects.get(listingID=listingid)
    review_data = s.ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': serializer.data, 'reviewData':review_data.data,'Addons':addons_serializer.data,'Packages':package_serializer.data,  'Listing':listing_serializer.data, 
                    'Package': package_serializer.data, 'Review': review_serializer.data,'pictures':picture_serializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def caterer_view_page(request,listingid):
    caterer_id= listingid
    caterer_view = m.Caterers.objects.get(listingId = caterer_id)
    listing = m.Listing.objects.get(id = caterer_id)
    addons = m.AddOns.objects.filter(listingId =  caterer_id)
    package = m.Packages.objects.filter(listingId =  caterer_id)
    review = m.Review.objects.filter(listingID = caterer_id)
    pic = m.PicturesListings.objects.filter(listingId= caterer_id)
    product = m.Product.objects.filter(listingId=caterer_id)
    menu = s.ProductsSerializer(product, many=True)
    picture_serializer = s.PicturesListingSerializers(pic, many=True)
    review_serializer = s.ReviewSerializer( review, many = True)
    package_serializer = s.PackagesSerializer( package, many = True)
    addons_serializer = s.AddOnsSerializer( addons, many = True)
    serializer = s.CaterersSerializer( caterer_view, many=False)
    listing_serializer = s.ListingSerializer (listing, many =False)
    bookings = m.Booking.objects.filter(
            listing_id=listingid,
            status__in=['confirmed', 'completed'] 
        )
        
    booked_dates = [booking.booking_date for booking in bookings]
    review_data= m.ReviewDetails.objects.get(listingID=listingid)
    review_data = s.ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': serializer.data,
    'bookedDates':booked_dates,
    'menu':menu.data,
                    'Addons': addons_serializer.data,'reviewData':review_data.data,
    'Package': package_serializer.data,'Review': review_serializer.data, 'Listing': listing_serializer.data,'pictures':picture_serializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def video_editor_view_page(request, videoeditorid):
    listing =m.Listing.objects.get(id = videoeditorid)
    video_editors = m.VideoEditors.objects.get(listingId = videoeditorid)
    addons = m.AddOns.objects.filter(listingId =  videoeditorid)
    package = m.Packages.objects.filter(listingId =  videoeditorid)
    review = m.Review.objects.filter(listingId = videoeditorid)
    pic = m.PicturesListings.objects.filter(listingId= videoeditorid)
    picture_serializer = s.PicturesListingSerializers(pic, many=True)
    addons_serializer = s.AddOnsSerializer( addons, many = True)
    video_editors_serializer = s.VideoEditorsSerializer(video_editors, many =False)
    package_serializer = s.PackagesSerializer(package, many = True)
    review_serializer = s.ReviewSerializer(review,many=True)
    listing_serializer = s.ListingSerializer(listing, many=False)
    review_data= m.ReviewDetails.objects.get(listingID=videoeditorid)
    review_data = s.ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': video_editors_serializer.data,'reviewData':review_data.data, 'Addons':addons_serializer.data,  'Listing':listing_serializer.data, 
                     'Package': package_serializer.data, 'Review': review_serializer.data,'pictures':picture_serializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def venue_view_page(request, listingid):
    venue_id = listingid
    listing = m.Listing.objects.get(id = venue_id)
    venue_view = m.Venue.objects.get(listingID= venue_id)
    addons = m.AddOns.objects.filter(listingId = venue_id)
    package = m.Packages.objects.filter(listingId = venue_id)
    review = m.Review.objects.filter(listingID =venue_id)
    pic = m.PicturesListings.objects.filter(listingId=venue_id)
    picture_serializer = s.PicturesListingSerializers(pic, many=True)
    review_serializer = s.ReviewSerializer( review, many = True)
    package_serializer = s.PackagesSerializer( package, many = True)
    bookings = m.Booking.objects.filter(
            listing_id=listingid,
            status__in=['confirmed', 'completed'] 
        )
        
    booked_dates = [booking.booking_date for booking in bookings]
    addons_serializer = s.AddOnsSerializer( addons, many = True)
    serializer = s.VenueSerializer( venue_view, many=False)
    listing_serializer = s.ListingSerializer (listing, many =False)
    review_data= m.ReviewDetails.objects.get(listingID=listingid)
    review_data = s.ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': addons_serializer.data,'reviewData':review_data.data,
    'Package': package_serializer.data,'Review': review_serializer.data, 'Listing': listing_serializer.data,'pictures':picture_serializer.data,'bookedDates':booked_dates})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def salon_view_page(request, listingid):
    salon_view = m.Salons.objects.get(listingId = listingid)
    listing = m.Listing.objects.get(id = listingid)
    addons = m.AddOns.objects.filter(listingId = listingid)
    package = m.Packages.objects.filter(listingId = listingid)
    review = m.Review.objects.filter(listingID =listingid)
    pic = m.PicturesListings.objects.filter(listingId=listingid)
    picture_serializer = s.PicturesListingSerializers(pic, many=True)
    review_serializer = s.ReviewSerializer( review, many = True)
    package_serializer = s.PackagesSerializer( package, many = True)
    addons_serializer = s.AddOnsSerializer( addons, many = True)
    serializer = s.SalonsSerializer( salon_view, many=False)
    listing_serializer = s.ListingSerializer (listing, many =False)
    review_data= m.ReviewDetails.objects.get(listingID=listingid)
    review_data = s.ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': addons_serializer.data,'reviewData':review_data.data,
    'Package': package_serializer.data,'Review': review_serializer.data, 'Listing': listing_serializer.data,'pictures':picture_serializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def parlour_view_page(request, listingid):
    parlor_view = m.Parlors.objects.get(listingId = listingid)
    listing = m.Listing.objects.get(id = listingid)
    addons = m.AddOns.objects.filter(listingId = listingid)
    package = m.Packages.objects.filter(listingId = listingid)
    review = m.Review.objects.filter(listingID =listingid)
    pic = m.PicturesListings.objects.filter(listingId=listingid)
    picture_serializer = s.PicturesListingSerializers(pic, many=True)
    review_serializer = s.ReviewSerializer( review, many = True)
    package_serializer = s.PackagesSerializer( package, many = True)
    addons_serializer = s.AddOnsSerializer( addons, many = True)
    serializer = s.ParlorsSerializer(parlor_view, many=False)
    listing_serializer = s.ListingSerializer (listing, many =False)
    review_data= m.ReviewDetails.objects.get(listingID=listingid)
    review_data = s.ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': addons_serializer.data,'reviewData':review_data.data,
    'Package': package_serializer.data,'Review': review_serializer.data, 'Listing': listing_serializer.data,'pictures':picture_serializer.data})


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def photography_places_view_page(request, listingid):
    photographer_view = m.PhotographyPlaces.objects.get( listingID =listingid)
    listing = m.Listing.objects.get(id = listingid)
    addons = m.AddOns.objects.filter(listingId = listingid)
    package = m.Packages.objects.filter(listingId = listingid)
    review = m.Review.objects.filter(listingID =listingid)
    pic = m.PicturesListings.objects.filter(listingId=listingid)
    picture_serializer = s.PicturesListingSerializers(pic, many=True)
    review_serializer = s.ReviewSerializer( review, many = True)
    package_serializer = s.PackagesSerializer( package, many = True)
    addons_serializer = s.AddOnsSerializer( addons, many = True)
    serializer = s.PhotographyPlacesSerializer( photographer_view, many=False)
    listing_serializer = s.ListingSerializer (listing, many =False)
    bookings = m.Booking.objects.filter(
            listing_id=listingid,
            status__in=['confirmed', 'completed'] 
        )
        
    booked_dates = [booking.booking_date for booking in bookings]
    review_data= m.ReviewDetails.objects.get(listingID=listingid)
    review_data = s.ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': addons_serializer.data,'reviewData':review_data.data,
    'Package': package_serializer.data,'Review': review_serializer.data, 'Listing': listing_serializer.data,'pictures':picture_serializer.data,'bookedDates':booked_dates})

@api_view(['GET'])
@permission_classes([AllowAny])
def decorator_detail_page(request,listingid):
    listing_details = m.Listing.objects.get(id=listingid)
    decorator_details = m.Decorators.objects.get(listingId=listingid)
    addons = m.AddOns.objects.filter(listingId = listingid)
    package = m.Packages.objects.filter(listingId = listingid)
    review = m.Review.objects.filter(listingID =listingid)
    pic = m.PicturesListings.objects.filter(listingId=listingid)
    picture_serializer = s.PicturesListingSerializers(pic, many=True)
    review_serializer = s.ReviewSerializer( review, many = True)
    package_serializer = s.PackagesSerializer( package, many = True)
    addons_serializer = s.AddOnsSerializer( addons, many = True)
    serializer = s.DecoratorsSerializer( decorator_details, many=False)
    listing_serializer = s.ListingSerializer (listing_details, many =False)
    review_data= m.ReviewDetails.objects.get(listingID=listingid)
    review_data = s.ReviewDetailsSerializer(review_data,many=False)
    return Response({'status': 'success','View': serializer.data,'reviewData':review_data.data,
                    'Addons': addons_serializer.data,
    'Package': package_serializer.data,'Review': review_serializer.data, 'Listing': listing_serializer.data,'pictures':picture_serializer.data})

@api_view(['POST'])
@permission_classes([AllowAny])
def add_review(request):
    review = request.data.get('review')
    rating = request.data.get('rating')
    listingid = request.data.get('listingId')
    userid = request.data.get('userId')
    listing = m.Listing.objects.get(id =listingid)
    user = m.User.objects.get(id = userid)
    review = m.Review(listingID = listing, userID = user, rating = rating, review = review)
    review.save()
    new_rating = float(listing.rating * listing.ratingCount) + float(rating)
    listing.ratingCount += 1
    listing.rating = new_rating/listing.ratingCount
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

