from . import models as mp
from rest_framework import serializers as s

class UserSerializer(s.ModelSerializer):
    class Meta:
        model = mp.User
        fields = '__all__'

class BusinessOwnerSerializer(s.ModelSerializer):
    class Meta:
        model = mp.BusinessOwner
        fields = '__all__'

class BookedSlotsSerializer(s.ModelSerializer):
    class Meta:
        model = mp.BookedSlots
        fields = '__all__'

class BookingCartSerializer(s.ModelSerializer):
    class Meta:
        model = mp.BookingCart
        fields = '__all__'

class PicturesListingSerializers(s.ModelSerializer):
    class Meta:
        model = mp.PicturesListings
        fields = '__all__'


class FreelancerSerializer(s.ModelSerializer):
    class Meta:
        model = mp.Freelancer
        fields = '__all__'

class ListingSerializer(s.ModelSerializer):
    class Meta:
        model = mp.Listing
        fields = '__all__'

class PackagesSerializer(s.ModelSerializer):
    class Meta:
        model = mp.Packages
        fields = '__all__'
        
class OrdersSerializer(s.ModelSerializer):
    class Meta:
        model = mp.Orders
        fields = '__all__'


class CartSerializer(s.ModelSerializer):
    class Meta:
        model = mp.Cart
        fields = '__all__'


class AIEventQuestionsSerializer(s.ModelSerializer):
    class Meta:
        model = mp.AIEventQuestions
        fields = '__all__'


class QuestionOptionsSerializer(s.ModelSerializer):
    class Meta:
        model = mp.QuestionOptions
        fields = '__all__'

class ReviewSerializer(s.ModelSerializer):
    class Meta:
        model = mp.Review
        fields = '__all__'

class EventsSerializer(s.ModelSerializer):
    class Meta:
        model = mp.Events
        fields = '__all__'

class FunctionsSerializer(s.ModelSerializer):
    class Meta:
        model = mp.Functions
        fields = '__all__'

class GuestListSerializer(s.ModelSerializer):
    class Meta:
        model = mp.GuestList
        fields = '__all__'


class CheckListSerializer(s.ModelSerializer):
    class Meta:
        model = mp.CheckList
        fields = '__all__'


class VenueSerializer(s.ModelSerializer):
    class Meta:
        model = mp.Venue
        fields = '__all__'



class AddOnsSerializer(s.ModelSerializer):
    class Meta:
        model = mp.AddOns
        fields = '__all__'

class CaterersSerializer(s.ModelSerializer):
    class Meta:
        model = mp.Caterers
        fields = '__all__'


class MenuItemsSerializer(s.ModelSerializer):
    class Meta:
        model = mp.MenuItems
        fields = '__all__'



class PhotographersSerializer(s.ModelSerializer):
    class Meta:
        model = mp.Photographers
        fields = '__all__'


class CarRentersSerializer(s.ModelSerializer):
    class Meta:
        model = mp.CarRenters
        fields = '__all__'


class CarsSerializer(s.ModelSerializer):
    class Meta:
        model = mp.Cars
        fields = '__all__'

class DecoratorsSerializer(s.ModelSerializer):
    class Meta:
        model = mp.Decorators
        fields = '__all__'

class PhotographyPlacesSerializer(s.ModelSerializer):
    class Meta:
        model = mp.PhotographyPlaces
        fields = '__all__'

class ParlorsSerializer(s.ModelSerializer):
    class Meta:
        model = mp.Parlors
        fields = '__all__'

class HomePageImagesSerializer(s.ModelSerializer):
    class Meta:
        model = mp.HomePageImages
        fields = '__all__'

class SalonsSerializer(s.ModelSerializer):
    class Meta:
        model = mp.Salons
        fields = '__all__'

class BakersAndSweetsSerializer(s.ModelSerializer):
    class Meta:
        model = mp.BakersAndSweets
        fields = '__all__'

class VideoEditorsSerializer(s.ModelSerializer):
    class Meta:
        model = mp.VideoEditors
        fields = '__all__'

class GraphicDesignersSerializer(s.ModelSerializer):
    class Meta:
        model = mp.GraphicDesigners
        fields = '__all__'


class EventTypeSerializer(s.ModelSerializer):
    class Meta:
        model = mp.EventType
        fields = '__all__'


class FunctionTypeSerializer(s.ModelSerializer):
    class Meta:
        model = mp.FunctionType
        fields = '__all__'


class DesertItemsSerializer(s.ModelSerializer):
    class Meta:
        model = mp.DesertItems
        fields = '__all__'

class CategoriesSerializer(s.ModelSerializer):
    class Meta:
        model = mp.Categories
        fields = '__all__'
