from . import models as mp
from rest_framework import serializers as s
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework.exceptions import AuthenticationFailed
from .models import User
# from .models import User, UserActivity, 

class CustomJWTAuthentication(JWTAuthentication):
    def get_user(self, validated_token):
        try:
            # Extract the user ID from the token payload
            user_id = validated_token.get('user_id')

            if user_id is None:
                raise AuthenticationFailed('Token payload missing "user_id".')

            # Fetch the user from the custom `User` table
            user = User.objects.get(id=user_id)

            return user

        except User.DoesNotExist:
            raise AuthenticationFailed('User not found')

from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)

        # Add custom fields to the token
        token['user_id'] = user.id
        token['email'] = user.email
        token['first_name'] = user.firstName
        token['last_name'] = user.lastName

        return token


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

class WishlistSerializer(s.ModelSerializer):
    class Meta:
        model = mp.Wishlist
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

class PicturesPackagesSerializer(s.ModelSerializer):
    class Meta:
        model = mp.PicturesPackages
        fields = ['picturePath']  # Only include the picturePath field


class PackagesSerializer(s.ModelSerializer):
    pictures = PicturesPackagesSerializer(
        many=True,
        read_only=True,
        source='picturespackages_set'  # This is the default related_name for reverse FK
    )
    
    class Meta:
        model = mp.Packages
        fields = ['id', 'name', 'listingId', 'description', 'price', 'pictures']

        
# class OrdersSerializer(s.ModelSerializer):
#     class Meta:
#         model = mp.Orders
#         fields = '__all__'


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

class ReviewDetailsSerializer(s.ModelSerializer):
    class Meta:
        model = mp.ReviewDetails
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

class BusinessTransactionSerializer(s.ModelSerializer):
    class Meta:
        model = mp.BusinessTransaction
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

# class BakersAndSweetsSerializer(s.ModelSerializer):
#     class Meta:
#         model = mp.BakersAndSweets
#         fields = '__all__'

class BankDetailsSerializer(s.ModelSerializer):
    masked_account_number = s.SerializerMethodField()
    
    class Meta:
        model = mp.BankDetails
        fields = [
            'bankName',
            'masked_account_number',  # This will show the masked version
        ]
        extra_kwargs = {
            'accountNumber': {'write_only': True}  # Hide original in responses
        }
    
    def get_masked_account_number(self, obj):
        """Returns the account number with all but last 4 digits masked"""
        if not obj.accountNumber:
            return None
        
        # Get last 4 digits
        visible_digits = 4
        num_length = len(obj.accountNumber)
        last_digits = obj.accountNumber[-visible_digits:]
        
        # Return masked version (e.g., ******1234)
        return '*' * (num_length - visible_digits) + last_digits


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


# class DesertItemsSerializer(s.ModelSerializer):
#     class Meta:
#         model = mp.DesertItems
#         fields = '__all__'

class CategoriesSerializer(s.ModelSerializer):
    class Meta:
        model = mp.Categories
        fields = '__all__'

class UserActivitySerializer(s.ModelSerializer):
    class Meta:
        model = mp.UserActivity
        fields = '__all__' 


# class UserEventSerializer(s.ModelSerializer):
#     class Meta:
#         model = mp.UserEvent
#         exclude = ['user']  # ✅ The user is assigned automatically when creating an event