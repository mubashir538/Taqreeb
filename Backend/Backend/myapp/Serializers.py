import datetime
import json
from . import models as m
from rest_framework import serializers as s
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework.exceptions import AuthenticationFailed
from .models import User
from django.core.exceptions import ValidationError
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
# from .models import User, UserActivity, 

# class CustomJWTAuthentication(JWTAuthentication):
#     def get_user(self, validated_token):
#         try:
#             # Extract the user ID from the token payload
#             user_id = validated_token.get('user_id')

#             if user_id is None:
#                 raise AuthenticationFailed('Token payload missing "user_id".')

#             # Fetch the user from the custom `User` table
#             user = User.objects.get(id=user_id)

#             return user

#         except User.DoesNotExist:
#             raise AuthenticationFailed('User not found')


# class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
#     @classmethod
#     def get_token(cls, user):
#         token = super().get_token(user)

#         # Add custom fields to the token
#         token['user_id'] = user.id
#         token['email'] = user.email
#         token['first_name'] = user.firstName
#         token['last_name'] = user.lastName

#         return token


# class UserSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.User
#         fields = '__all__'

# class BusinessOwnerSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.BusinessOwner
#         fields = '__all__'

# class BookingCartSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.BookingCart
#         fields = '__all__'

# class WishlistSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.Wishlist
#         fields = '__all__'

# class PicturesListingSerializers(s.ModelSerializer):
#     class Meta:
#         model = m.PicturesListings
#         fields = '__all__'


# class FreelancerSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.Freelancer
#         fields = '__all__'

# class ListingSerializer(s.ModelSerializer):
#     booked_dates = s.SerializerMethodField()

#     class Meta:
#         model = m.Listing
#         fields = '__all__'
#         extra_kwargs = {
#             'booked_dates': {'write_only': True}
#         }

#     def get_booked_dates(self, obj):
#         """Convert the booked_dates JSON field to a proper list when reading"""
#         if isinstance(obj.booked_dates, str):
#             try:
#                 return json.loads(obj.booked_dates)
#             except json.JSONDecodeError:
#                 return []
#         return obj.booked_dates or []

#     def to_internal_value(self, data):
#         """Handle incoming data before validation"""
#         if 'booked_dates' in data:
#             if isinstance(data['booked_dates'], str):
#                 try:
#                     data['booked_dates'] = json.loads(data['booked_dates'])
#                 except json.JSONDecodeError:
#                     raise ValidationError({'booked_dates': 'Invalid JSON format'})
#             elif not isinstance(data['booked_dates'], list):
#                 raise ValidationError({'booked_dates': 'Must be a list'})
#         return super().to_internal_value(data)

#     def validate_booked_dates(self, value):
#         """Validate each date in the booked_dates list"""
#         if not isinstance(value, list):
#             raise s.ValidationError("Booked dates must be a list")

#         valid_dates = []
#         for date_str in value:
#             try:
#                 # Validate date format
#                 parsed_date = datetime.fromisoformat(date_str.replace('Z', '+00:00'))
#                 valid_dates.append(parsed_date.isoformat())
#             except (ValueError, AttributeError):
#                 raise s.ValidationError(
#                     f"Invalid date format: {date_str}. Use ISO 8601 format."
#                 )

#         return valid_dates

#     def create(self, validated_data):
#         """Ensure booked_dates is properly stored as JSON"""
#         if 'booked_dates' in validated_data:
#             validated_data['booked_dates'] = json.dumps(validated_data['booked_dates'])
#         return super().create(validated_data)

#     def update(self, instance, validated_data):
#         """Ensure booked_dates is properly stored as JSON"""
#         if 'booked_dates' in validated_data:
#             validated_data['booked_dates'] = json.dumps(validated_data['booked_dates'])
#         return super().update(instance, validated_data)

# class PicturesPackagesSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.PicturesPackages
#         fields = ['picturePath']  # Only include the picturePath field

# class PicturesProductsSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.PicturesProducts
#         fields = ['picturePath']  # Only include the picturePath field

# class PackagesSerializer(s.ModelSerializer):
#     pictures = PicturesPackagesSerializer(
#         many=True,
#         read_only=True,
#         source='picturespackages_set'  # This is the default related_name for reverse FK
#     )
    
#     class Meta:
#         model = m.Packages
#         fields = ['id', 'name', 'listingId', 'description', 'price', 'pictures']

# class ProductsSerializer(s.ModelSerializer):
#     pictures = PicturesProductsSerializer(
#         many=True,
#         read_only=True,
#         source='picturesproducts_set'  # This is the default related_name for reverse FK
#     )
    
#     class Meta:
#         model = m.Product
#         fields = ['id', 'name', 'listingId', 'description', 'price', 'pictures']

# class ReviewSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.Review
#         fields = '__all__'

# class ReviewDetailsSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.ReviewDetails
#         fields = '__all__'

# class EventsSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.Events
#         fields = '__all__'

# class FunctionsSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.Functions
#         fields = '__all__'

# class GuestListSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.GuestList
#         fields = '__all__'


# class CheckListSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.CheckList
#         fields = '__all__'
# class VenueSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.Venue
#         fields = '__all__'

# class AddOnsSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.AddOns
#         fields = '__all__'

# class CaterersSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.Caterers
#         fields = '__all__'

# class PhotographersSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.Photographers
#         fields = '__all__'


# class CarRentersSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.CarRenters
#         fields = '__all__'

# class DecoratorsSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.Decorators
#         fields = '__all__'

# class PhotographyPlacesSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.PhotographyPlaces
#         fields = '__all__'

# class ParlorsSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.Parlors
#         fields = '__all__'

# class HomePageImagesSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.HomePageImages
#         fields = '__all__'

# class SalonsSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.Salons
#         fields = '__all__'

# class BankDetailsSerializer(s.ModelSerializer):
#     masked_account_number = s.SerializerMethodField()
    
#     class Meta:
#         model = m.BankDetails
#         fields = [
#             'bankName',
#             'masked_account_number',  # This will show the masked version
#         ]
#         extra_kwargs = {
#             'accountNumber': {'write_only': True}  # Hide original in responses
#         }
    
#     def get_masked_account_number(self, obj):
#         """Returns the account number with all but last 4 digits masked"""
#         if not obj.accountNumber:
#             return None
        
#         # Get last 4 digits
#         visible_digits = 4
#         num_length = len(obj.accountNumber)
#         last_digits = obj.accountNumber[-visible_digits:]
        
#         # Return masked version (e.g., ******1234)
#         return '*' * (num_length - visible_digits) + last_digits


# class VideoEditorsSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.VideoEditors
#         fields = '__all__'

# class GraphicDesignersSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.GraphicDesigners
#         fields = '__all__'


# class EventTypeSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.EventType
#         fields = '__all__'


# class FunctionTypeSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.FunctionType
#         fields = '__all__'

# class CategoriesSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.Categories
#         fields = '__all__'

# class UserActivitySerializer(s.ModelSerializer):
#     class Meta:
#         model = m.UserActivity
#         fields = '__all__' 
# class CartItemSerializer(s.ModelSerializer):
#     item_details = s.SerializerMethodField()
    
#     class Meta:
#         model = m.CartItem
#         fields = ['id', 'item_type', 'item_id', 'quantity', 'added_at', 'item_details']
    
#     def get_item_details(self, obj):
#         if obj.item_type == 'listing':
#             item = m.Listing.objects.filter(id=obj.item_id).first()
#             return ListingSerializer(item).data if item else None
#         elif obj.item_type == 'product':
#             item = m.Product.objects.filter(id=obj.item_id).first()
#             return ProductsSerializer(item).data if item else None
#         elif obj.item_type == 'package':
#             item = m.Packages.objects.filter(id=obj.item_id).first()
#             return PackagesSerializer(item).data if item else None
#         return None

# class CartSerializer(s.ModelSerializer):
#     items = CartItemSerializer(many=True, read_only=True)
#     total_items = s.SerializerMethodField()
#     total_price = s.SerializerMethodField()
    
#     class Meta:
#         model = m.Cart
#         fields = ['id', 'user', 'created_at', 'updated_at', 'items', 'total_items', 'total_price']
    
#     def get_total_items(self, obj):
#         return obj.items.count()
    
#     def get_total_price(self, obj):
#         total = 0
#         for item in obj.items.all():
#             if item.item_type == 'listing':
#                 listing = m.Listing.objects.filter(id=item.item_id).first()
#                 total += listing.priceMin * item.quantity if listing else 0
#             elif item.item_type == 'product':
#                 product = m.Product.objects.filter(id=item.item_id).first()
#                 total += product.price * item.quantity if product else 0
#             elif item.item_type == 'package':
#                 package = m.Packages.objects.filter(id=item.item_id).first()
#                 total += package.price * item.quantity if package else 0
#         return total
    
# class BookingSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.Booking
#         fields = '__all__'

# class OrderSerializer(s.ModelSerializer):
#     bookings = BookingSerializer(many=True, read_only=True)
    
#     class Meta:
#         model = m.Order
#         fields = '__all__'

# serializers.py
# class PaymentSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.Payment
#         fields = '__all__'

# class TransactionSerializer(s.ModelSerializer):
#     package = PackagesSerializer(read_only=True)
#     booking = BookingSerializer(read_only=True)
    
#     class Meta:
#         model = m.Transaction
#         fields = '__all__'

# class BusinessTransactionSerializer(s.ModelSerializer):
#     class Meta:
#         model = m.BusinessTransaction
#         fields = '__all__'