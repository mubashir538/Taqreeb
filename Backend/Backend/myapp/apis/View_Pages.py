from .. import models as md
from .. import Serializers as s
import random as rd
from rest_framework.decorators import api_view, permission_classes
from django.conf import settings
from rest_framework.permissions import IsAuthenticated,AllowAny
from django.apps import apps
from rest_framework.response import Response
import math

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def PhotographerViewPage(request, listingid):
    PhotographerView = md.Photographers.objects.get( listingId = listingid)
    Listing = md.Listing.objects.get(id = listingid)
    Addons = md.AddOns.objects.filter(listingId = listingid)
    Package = md.Packages.objects.filter(listingId = listingid)
    Review = md.Review.objects.filter(listingID =listingid)
    pic = md.PicturesListings.objects.filter(listingId=listingid)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.PhotographersSerializer( PhotographerView, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    bookedDates = md.BookedSlots.objects.filter(listingId=listingid)
    bookedDatesSerializer = s.BookedSlotsSerializer(bookedDates, many=True)
    reviewData= md.ReviewDetails.objects.get(listingID=listingid)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': Addonsserializer.data,'reviewData':reviewData.data,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data,'bookedDates':bookedDatesSerializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def CarRenterViewPage(request, listingid):
    Listing = md.Listing.objects.get(id = listingid)
    CarRenters = md.CarRenters.objects.get(listingID = listingid)
    Cars = md.Cars.objects.filter(id =CarRenters.id)
    CarsSerializer = s.CarsSerializer(Cars , many = True)
    Addons = md.AddOns.objects.filter(listingId = listingid)
    Package = md.Packages.objects.filter(listingId = listingid)
    Review = md.Review.objects.filter(listingID =listingid)
    pic = md.PicturesListings.objects.filter(listingId=listingid)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.CarRentersSerializer(CarRenters, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    reviewData= md.ReviewDetails.objects.get(listingID=listingid)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': Addonsserializer.data,'reviewData':reviewData.data,
                    'cars':CarsSerializer.data,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def GraphicDesignerViewPage(request, listingid):
    graphicdesignerid = listingid
    Listing = md.Listing.objects.get(id= graphicdesignerid)
    GraphicDesigners = md.GraphicDesigners.objects.get(listingId = graphicdesignerid)
    Addons = md.AddOns.objects.filter(listingId = listingid)
    Package = md.Packages.objects.filter(listingId = listingid)
    Review = md.Review.objects.filter(listingID =listingid)
    pic = md.PicturesListings.objects.filter(listingId=listingid)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.GraphicDesignersSerializer(GraphicDesigners,many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    reviewData= md.ReviewDetails.objects.get(listingID=listingid)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': serializer.data, 'reviewData':reviewData.data,'Addons':Addonsserializer.data,'Packages':Packageserializer.data,  'Listing':Listingserializer.data, 
                    'Package': Packageserializer.data, 'Review': Reviewserializer.data,'pictures':pictureSerializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def CatererViewPage(request,listingid):
    CatererID= listingid
    CatererView = md.Caterers.objects.get(listingId = CatererID)
    Listing = md.Listing.objects.get(id = CatererID)
    Addons = md.AddOns.objects.filter(listingId =  CatererID)
    Package = md.Packages.objects.filter(listingId =  CatererID)
    Review = md.Review.objects.filter(listingID = CatererID)
    pic = md.PicturesListings.objects.filter(listingId= CatererID)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.CaterersSerializer( CatererView, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    bookedDates = md.BookedSlots.objects.filter(listingId=listingid)
    bookedDatesSerializer = s.BookedSlotsSerializer(bookedDates, many=True)
    reviewData= md.ReviewDetails.objects.get(listingID=listingid)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': serializer.data,
    'bookedDates':bookedDatesSerializer.data,
                    'Addons': Addonsserializer.data,'reviewData':reviewData.data,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def VideoEditorViewPage(request, VideoEditorID):
    Listing =md.Listing.objects.get(id = VideoEditorID)
    VideoEditors = md.VideoEditors.objects.get(listingId = VideoEditorID)
    Addons = md.AddOns.objects.filter(listingId =  VideoEditorID)
    Package = md.Packages.objects.filter(listingId =  VideoEditorID)
    Review = md.Review.objects.filter(listingId = VideoEditorID)
    pic = md.PicturesListings.objects.filter(listingId= VideoEditorID)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    VideoEditorsSerializer = s.VideoEditorsSerializer(VideoEditors, many =False)
    PackageSerializer = s.PackagesSerializer(Package, many = True)
    ReviewSerializer = s.ReviewSerializer(Review,many=True)
    ListingSerializer = s.ListingSerializer(Listing, many=False)
    reviewData= md.ReviewDetails.objects.get(listingID=VideoEditorID)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': VideoEditorsSerializer.data,'reviewData':reviewData.data, 'Addons':Addonsserializer.data,  'Listing':ListingSerializer.data, 
                     'Package': PackageSerializer.data, 'Review': ReviewSerializer.data,'pictures':pictureSerializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def VenueViewPage(request, listingid):
    venueId = listingid
    Listing = md.Listing.objects.get(id = venueId)
    VenueView = md.Venue.objects.get(listingID= venueId)
    Addons = md.AddOns.objects.filter(listingId = venueId)
    Package = md.Packages.objects.filter(listingId = venueId)
    Review = md.Review.objects.filter(listingID =venueId)
    pic = md.PicturesListings.objects.filter(listingId=venueId)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.VenueSerializer( VenueView, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    bookedDates = md.BookedSlots.objects.filter(listingId=venueId)
    bookedDatesSerializer = s.BookedSlotsSerializer(bookedDates, many=True)
    reviewData= md.ReviewDetails.objects.get(listingID=listingid)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': Addonsserializer.data,'reviewData':reviewData.data,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data,'bookedDates':bookedDatesSerializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def SalonViewPage(request, listingid):
    salonView = md.Salons.objects.get(listingId = listingid)
    Listing = md.Listing.objects.get(id = listingid)
    Addons = md.AddOns.objects.filter(listingId = listingid)
    Package = md.Packages.objects.filter(listingId = listingid)
    Review = md.Review.objects.filter(listingID =listingid)
    pic = md.PicturesListings.objects.filter(listingId=listingid)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.SalonsSerializer( salonView, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    reviewData= md.ReviewDetails.objects.get(listingID=listingid)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': Addonsserializer.data,'reviewData':reviewData.data,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def ParlourViewPage(request, listingid):
    parlorView = md.Parlors.objects.get(listingId = listingid)
    Listing = md.Listing.objects.get(id = listingid)
    Addons = md.AddOns.objects.filter(listingId = listingid)
    Package = md.Packages.objects.filter(listingId = listingid)
    Review = md.Review.objects.filter(listingID =listingid)
    pic = md.PicturesListings.objects.filter(listingId=listingid)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.ParlorsSerializer(parlorView, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    reviewData= md.ReviewDetails.objects.get(listingID=listingid)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': Addonsserializer.data,'reviewData':reviewData.data,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def BakersViewPage(request, listingid):
    bakers = md.BakersAndSweets.objects.get( listingID =listingid)
    Listing = md.Listing.objects.get(id = listingid)
    Package = md.Packages.objects.filter(listingId = listingid)
    Review = md.Review.objects.filter(listingID =listingid)
    cakes = md.DesertItems.objects.filter(bakersId = bakers.id)
    pic = md.PicturesListings.objects.filter(listingId=listingid)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    serializer = s.BakersAndSweetsSerializer( bakers, many=False)
    cakeSerializer  = s.DesertItemsSerializer(cakes, many=True)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    reviewData= md.ReviewDetails.objects.get(listingID=listingid)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': serializer.data, 'items':cakeSerializer.data,'reviewData':reviewData.data,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def PhotographyPlacesViewPage(request, listingid):
    PhotographerView = md.PhotographyPlaces.objects.get( listingID =listingid)
    Listing = md.Listing.objects.get(id = listingid)
    Addons = md.AddOns.objects.filter(listingId = listingid)
    Package = md.Packages.objects.filter(listingId = listingid)
    Review = md.Review.objects.filter(listingID =listingid)
    pic = md.PicturesListings.objects.filter(listingId=listingid)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.PhotographyPlacesSerializer( PhotographerView, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    bookedDates = md.BookedSlots.objects.filter(listingId=listingid)
    bookedDatesSerializer = s.BookedSlotsSerializer(bookedDates, many=True)
    reviewData= md.ReviewDetails.objects.get(listingID=listingid)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': Addonsserializer.data,'reviewData':reviewData.data,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data,'bookedDates':bookedDatesSerializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def DecoratorDetailPage(request,listingId):
    listingDetails = md.Listing.objects.get(id=listingId)
    decoratorDetails = md.Decorators.objects.get(listingId=listingId)
    Addons = md.AddOns.objects.filter(listingId = listingId)
    Package = md.Packages.objects.filter(listingId = listingId)
    Review = md.Review.objects.filter(listingID =listingId)
    pic = md.PicturesListings.objects.filter(listingId=listingId)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.DecoratorsSerializer( decoratorDetails, many=False)
    Listingserializer = s.ListingSerializer (listingDetails, many =False)
    bookedDates = md.BookedSlots.objects.filter(listingId=listingId)
    bookedDatesSerializer = s.BookedSlotsSerializer(bookedDates, many=True)
    reviewData= md.ReviewDetails.objects.get(listingID=listingId)
    reviewData = s.ReviewDetailsSerializer(reviewData,many=False)
    return Response({'status': 'success','View': serializer.data,'reviewData':reviewData.data,
                    'Addons': Addonsserializer.data,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data,'bookedDates':bookedDatesSerializer.data})

@api_view(['POST'])
@permission_classes([AllowAny])
def AddReview(request):
    review = request.data.get('review')
    rating = request.data.get('rating')
    listingId = request.data.get('listingId')
    userId = request.data.get('userId')
    Review = md.Review(listingID = listingId, userID = userId, rating = rating, review = review)
    Review.save()
    listing = md.Listing.objects.get(id =listingId)
    newRating = (listing.rating * listing.ratingCount) + rating
    listing.ratingCount +=1
    listing.rating = newRating/listing.ratingCount
    listing.save(update_fields=['ratingCount','rating']) 
    rdetails = md.ReviewDetails.objects.filter(listingID=listing).first()
    rating = math.floor(rating)
    if not rdetails:
        rdetails = md.ReviewDetails(listingID=listing)
        rdetails.save()
        rdetails = md.ReviewDetails.objects.filter(listingID=listing).first()
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

