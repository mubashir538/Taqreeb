# from django.db import models as m
# from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
# import os
# from django.contrib.auth import get_user_model
# from django.utils import timezone

# class CustomUserManager(BaseUserManager):
#     def create_user(self, id, password=None, **extra_fields):
#         """
#         Create and return a regular user with an id and password.
#         """
#         if not id:
#             raise ValueError('The ID field must be set')

#         user = self.model(id=id, **extra_fields)
#         user.set_password(password)
#         user.save(using=self._db)
#         return user

#     def create_superuser(self, id, password=None, **extra_fields):
#         """
#         Create and return a superuser with an id and password.
#         Superusers are created with `is_staff` and `is_superuser` set to True.
#         """
#         extra_fields.setdefault('is_staff', True)
#         extra_fields.setdefault('is_superuser', True)

#         return self.create_user(id, password, **extra_fields)

# class User(AbstractBaseUser, PermissionsMixin):
#     id = m.AutoField(primary_key=True)
#     firstName = m.CharField(max_length=100)
#     lastName = m.CharField(max_length=100)
#     password = m.CharField(max_length=10000,null=True)
#     contactNumber = m.CharField(max_length=15,null=True)
#     email = m.CharField(max_length=50,null=True)
#     city = m.CharField(max_length=50,null=True)
#     username = m.CharField(max_length=50,null=True)
#     age = m.IntegerField(null=True)
#     gender = m.CharField(max_length=6,null=True)
#     date_joined = m.DateTimeField(auto_now_add=True, null=True)

#     USERNAME_FIELD = 'id'
#     REQUIRED_FIELDS = ['password', 'firstName', 'lastName', 'city', 'gender']
#     def __str__(self):
#         return str(self.id)
#     # Add these lines to customize related_name
#     groups = m.ManyToManyField(
#         'auth.Group',
#         verbose_name='groups',
#         blank=True,
#         help_text='The groups this user belongs to.',
#         related_name="flutter_user_set",  # Unique related_name
#         related_query_name="flutter_user",
#     )
#     user_permissions = m.ManyToManyField(
#         'auth.Permission',
#         verbose_name='user permissions',
#         blank=True,
#         help_text='Specific permissions for this user.',
#         related_name="flutter_user_set",  # Unique related_name
#         related_query_name="flutter_user",
#     )


# class TempInvitationCard(m.Model):
#     file = m.ImageField(upload_to='uploads/tempCards/%Y/%m/%d/')
#     created_at = m.DateTimeField(auto_now_add=True)
#     def delete(self, *args, **kwargs):
#         if self.file and os.path.isfile(self.file.path):
#             os.remove(self.file.path)
#         super().delete(*args, **kwargs)

# class BusinessOwner(m.Model):
#     id = m.AutoField(primary_key=True)
#     cnic = m.TextField(blank=True)
#     userID = m.ForeignKey(User,on_delete=m.CASCADE)
#     CNICFront = m.CharField(max_length=100,blank=True)
#     CNICBack = m.CharField(max_length=100,blank=True)
#     businessName = m.CharField(max_length=100)
#     profilepic = m.CharField(max_length=200,blank=True)
#     Description = m.CharField(max_length=1100)
#     status = m.TextField(blank=True)
#     balance = m.IntegerField(default=0)

# class FCMTokens(m.Model):
#     id = m.AutoField(primary_key=True)
#     token = m.TextField()
#     userid = m.ForeignKey(User,on_delete=m.CASCADE)

# class Freelancer(m.Model):
#     id = m.AutoField(primary_key=True)
#     userID = m.ForeignKey(User,on_delete=m.CASCADE)
#     businessName = m.CharField(max_length=100,blank=True)
#     portfolioLink= m.CharField(max_length=100)
#     cnic = m.CharField(max_length=50,blank=True)
#     profilepic = m.CharField(max_length=100,blank=True)
#     Description = m.CharField(max_length=1100)
#     status = m.TextField(blank=True)
#     balance = m.IntegerField(default=0)

# class Listing(m.Model):
#     id = m.AutoField(primary_key=True)
#     ownerID = m.ForeignKey(BusinessOwner,on_delete=m.CASCADE,null=True)
#     freelancerID = m.ForeignKey(Freelancer,on_delete=m.CASCADE,null=True)
#     name = m.CharField(max_length=100)
#     priceMin = m.IntegerField()
#     priceMax = m.IntegerField() 
#     location = m.CharField(max_length=100)
#     description = m.CharField(max_length=1100)
#     rating = m.DecimalField(max_digits=2, decimal_places=1,default=0)
#     ratingCount = m.IntegerField(default=0)
#     basicPrice = m.IntegerField()
#     type = m.TextField(blank=True)
#     status = m.CharField(max_length=20,default='active')
#     booked_dates = m.JSONField(default=list)
#     created_at = m.DateTimeField(default=timezone.now)

# class BankDetails(m.Model):
#     id = m.AutoField(primary_key=True)
#     userID = m.ForeignKey(User,on_delete=m.CASCADE)
#     bankName = m.TextField()
#     accountNumber = m.TextField()
#     IBANNumber = m.TextField()
#     accountHolderName = m.TextField()

# class PicturesListings(m.Model):
#     id = m.AutoField(primary_key=True)
#     listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
#     picturePath = m.CharField(max_length=100)

# class Packages(m.Model):
#     id = m.AutoField(primary_key=True)
#     name = m.CharField(max_length=100,default='Basic')
#     listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
#     description = m.CharField(max_length=1100)
#     price= m.IntegerField()

# class PicturesPackages(m.Model):
#     id = m.AutoField(primary_key=True)
#     packageId = m.ForeignKey(Packages,on_delete=m.CASCADE)
#     picturePath = m.CharField(max_length=100)

# class Events(m.Model):
#     id = m.AutoField(primary_key=True)
#     name =m.CharField(max_length=100)
#     userID =  m.ForeignKey(User,on_delete= m.CASCADE,null=True)
#     type =m.CharField(max_length=100)
#     date =m.CharField(max_length=100)
#     location =m.CharField(max_length=100)
#     description =m.CharField(max_length=1100)
#     themeColor =m.CharField(max_length=100)
#     budget=  m.IntegerField()
#     guestsmin = m.IntegerField(null=True)
#     guestsmax = m.IntegerField(null=True) 

# class GuestList(m.Model):
#     id = m.AutoField(primary_key=True)
#     type = m.CharField(max_length=100)
#     name = m.CharField(max_length=100)
#     members = m.IntegerField(null=True)
#     phone = m.CharField(max_length=100,blank=True)
#     eventId = m.ForeignKey(Events,on_delete=m.CASCADE)
#     functionId = m.IntegerField(null=True)

# class Review(m.Model):
#     id = m.AutoField(primary_key=True)
#     listingID = m.ForeignKey(Listing,on_delete=m.CASCADE)
#     userID = m.ForeignKey(User,on_delete=m.CASCADE)
#     rating = m.DecimalField(max_digits=2, decimal_places=1)
#     review = m.CharField(max_length=100)
#     date = m.DateTimeField(auto_now_add=True,null=True)

# class ReviewDetails(m.Model):
#     id = m.AutoField(primary_key=True)
#     listingID = m.ForeignKey(Listing,on_delete=m.CASCADE)
#     s5 = m.IntegerField(default=0)
#     s4 = m.IntegerField(default=0)
#     s3 = m.IntegerField(default=0)
#     s2 = m.IntegerField(default=0)
#     s1 = m.IntegerField(default=0)

# class Functions(m.Model):
#     id = m.AutoField(primary_key=True)
#     eventId = m.ForeignKey(Events, on_delete=m.CASCADE)
#     name= m.CharField(max_length=100)
#     budget = m.IntegerField()
#     type = m.CharField(max_length=100)
#     date = m.DateField(null=True)
#     guestsmin = m.IntegerField(null=True)
#     guestsmax = m.IntegerField(null=True)

# class CheckList(m.Model):
#     id = m.AutoField(primary_key=True)
#     description = m.CharField(max_length=1100)
#     isChecked = m.BooleanField()
#     functionId = m.ForeignKey(Functions,on_delete=m.CASCADE,null=True)
#     eventId = m.ForeignKey(Events,on_delete=m.CASCADE)

# class AddOns(m.Model):
#     id = m.AutoField(primary_key=True)
#     name = m.CharField(max_length=255)
#     price = m.IntegerField()
#     isPer = m.BooleanField()
#     perType = m.CharField(max_length=50)
#     listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    
# class Parlors(m.Model):
#     id = m.AutoField(primary_key=True)
#     listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)

# class Salons(m.Model):
#     id = m.AutoField(primary_key=True)
#     listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)

# class Photographers(m.Model):
#     id = m.AutoField(primary_key=True)
#     listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
#     portfolioLink = m.CharField(max_length=100)

# class VideoEditors(m.Model):
#     id = m.AutoField(primary_key=True)
#     listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
#     portfolioLink = m.TextField()

# class GraphicDesigners(m.Model):
#     id = m.AutoField(primary_key=True)
#     listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
#     portfolioLink = m.CharField(max_length=100)

# class EventType(m.Model):
#     id = m.AutoField(primary_key=True)
#     name = m.CharField(max_length=100)

# class FunctionType(m.Model):
#     id = m.AutoField(primary_key=True)
#     name = m.TextField()
#     eventtypeid = m.ForeignKey(EventType,on_delete=m.CASCADE,null=True)

# class Wishlist(m.Model):
#     id = m.AutoField(primary_key=True)
#     user = m.ForeignKey(User,on_delete=m.CASCADE)
#     listing = m.ForeignKey(Listing,on_delete=m.CASCADE)

# class Categories(m.Model):
#     id = m.AutoField(primary_key=True)
#     name = m.CharField(max_length=255)
#     picture = m.CharField(max_length=255)
#     type = m.CharField(max_length=100,default='business')

# class Venue(m.Model):
#     id = m.AutoField(primary_key=True)
#     listingID = m.ForeignKey('Listing', on_delete=m.CASCADE)
#     VENUE_TYPE_CHOICES = [
#         ('Banquet', 'Banquet'),
#         ('Hall', 'Hall'),
#         ('Lawn', 'Lawn'),
#         ('Outdoor', 'Outdoor'),
#     ]
#     venueType = m.CharField(
#         max_length=50,
#         choices=VENUE_TYPE_CHOICES,
#         default='Banquet'
#     )
#     CATERING_CHOICES = [
#         ('Internal', 'Internal'),
#         ('External', 'External'),
#         ('Internal & External', 'Internal & External'),
#     ]
#     catering = m.CharField(
#         max_length=50,
#         choices=CATERING_CHOICES,
#         default='Internal'
#     )

#     # Choices for staff
#     STAFF_CHOICES = [
#         ('Male', 'Male'),
#         ('Female', 'Female'),
#         ('Both', 'Both'),
#     ]
#     staff = m.CharField(
#         max_length=10,
#         choices=STAFF_CHOICES,
#         default='Male'
#     )
#     guestminAllowed = m.IntegerField(default=0)
#     guestmaxAllowed = m.IntegerField(default=0)

#     def __str__(self):
#         return f"{self.listingID} - {self.venueType}"

# class BookedSlots(m.Model):
#     id = m.AutoField(primary_key=True)
#     slot = m.DateField()
#     listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)

# class HomePageImages(m.Model):
#     id = m.AutoField(primary_key=True)
#     image = m.CharField(max_length=255)

# class Caterers(m.Model):
#     id = m.AutoField(primary_key=True)
#     listingId = m.ForeignKey(Listing, on_delete=m.CASCADE)

#     SERVICE_TYPE_CHOICES = [
#         ('Wedding', 'Wedding'),
#         ('Corporate', 'Corporate'),
#         ('Birthday', 'Birthday'),
#         ('Anniversary', 'Anniversary'),
#         ('Other', 'Other'),
#     ]
#     CATERING_OPTIONS_CHOICES = [
#         ('Buffet', 'Buffet'),
#         ('Plated', 'Plated'),
#         ('Family Style', 'Family Style'),
#         ('Food Stations', 'Food Stations'),
#         ('Cocktail Reception', 'Cocktail Reception'),
#     ]
#     STAFF_CHOICES = [
#         ('Male', 'Male'),
#         ('Female', 'Female'),
#         ('Mixed', 'Mixed'),
#     ]
#     EXPERTISE_CHOICES = [
#         ('Pakistani', 'Pakistani'),
#         ('Chinese', 'Chinese'),
#         ('Continental', 'Continental'),
#         ('Italian', 'Italian'),
#         ('Desserts', 'Desserts'),
#     ]

#     serviceType = m.CharField(max_length=100, choices=SERVICE_TYPE_CHOICES, default='Wedding')
#     cateringOptions = m.CharField(max_length=100, choices=CATERING_OPTIONS_CHOICES, default='Buffet')
#     staff = m.CharField(max_length=100, choices=STAFF_CHOICES, default='Mixed')
#     expertise = m.CharField(max_length=100, choices=EXPERTISE_CHOICES, default='Pakistani')

# class CarRenters(m.Model):
#     id = m.AutoField(primary_key=True)
#     listingID = m.ForeignKey(Listing, on_delete=m.CASCADE)
#     SERVICE_TYPE_CHOICES = [
#         ('Luxury', 'Luxury'),
#         ('Economy', 'Economy'),
#         ('SUV', 'SUV'),
#         ('Convertible', 'Convertible'),
#         ('Van', 'Van'),
#     ]
#     serviceType = m.CharField(max_length=100, choices=SERVICE_TYPE_CHOICES, default='Economy')

# from .constants.model_constants import not_provided
# class Decorators(m.Model):
#     id = m.AutoField(primary_key=True)
#     listingId = m.ForeignKey(Listing, on_delete=m.CASCADE)

#     DECOR_TYPE_CHOICES = [
#         ('Floral', 'Floral'),
#         ('Lighting', 'Lighting'),
#         ('Drapery', 'Drapery'),
#         ('Furniture', 'Furniture'),
#         ('Themed', 'Themed'),
#     ]
#     CATERING_CHOICES = [
#         ('Provided', 'Provided'),
#         (not_provided, not_provided),
#     ]
#     STAFF_CHOICES = [
#         ('Male', 'Male'),
#         ('Female', 'Female'),
#         ('Mixed', 'Mixed'),
#     ]

#     decorType = m.CharField(max_length=50, choices=DECOR_TYPE_CHOICES, default='Floral')
#     catering = m.CharField(max_length=50, choices=CATERING_CHOICES, default='Not Provided')
#     staff = m.CharField(max_length=50, choices=STAFF_CHOICES, default='Mixed')

# class PhotographyPlaces(m.Model):
#     id = m.AutoField(primary_key=True)
#     listingID = m.ForeignKey(Listing, on_delete=m.CASCADE)

#     TYPE_CHOICES = [
#         ('Studio', 'Studio'),
#         ('Outdoor', 'Outdoor'),
#         ('Indoor', 'Indoor'),
#         ('Destination', 'Destination'),
#         ('Event', 'Event'),
#     ]

#     type = m.CharField(max_length=100, choices=TYPE_CHOICES, default='Studio')

# class UserActivity(m.Model):
#     ACTIONS = [
#         ('search', 'Search Query'),
#         ('category_click', 'Clicked Category'),
#         ('service_click', 'Clicked Service'),
#         ('filter', 'Applied Filter'),
#     ]
#     user = m.ForeignKey(User, on_delete=m.CASCADE)
#     action = m.CharField(max_length=50, choices=ACTIONS)
#     metadata = m.JSONField(null=True, blank=True)
#     timestamp = m.DateTimeField(auto_now_add=True)

#     def __str__(self):
#         return f"{self.user.username} - {self.action} - {self.timestamp}"

# class Product(m.Model):
#     id = m.AutoField(primary_key=True)
#     name = m.CharField(max_length=100)
#     description = m.TextField()
#     price = m.DecimalField(max_digits=10, decimal_places=2)
#     quantity = m.PositiveIntegerField(null=True)
#     listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)

# class PicturesProducts(m.Model):
#     id = m.AutoField(primary_key=True)
#     productId = m.ForeignKey(Product,on_delete=m.CASCADE)
#     picturePath = m.CharField(max_length=100)

# class BookingCart(m.Model):
#     id = m.AutoField(primary_key=True)
#     userId = m.ForeignKey(User,on_delete=m.CASCADE)
#     listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
#     functionId = m.ForeignKey(Functions,on_delete=m.CASCADE,null=True)
#     slot = m.DateTimeField(null=True)
#     type = m.CharField(max_length=100,blank=True)
#     status = m.CharField(max_length=100)

# User = get_user_model()

# class Cart(m.Model):
#     user = m.OneToOneField(User, on_delete=m.CASCADE, related_name='cart')
#     created_at = m.DateTimeField(auto_now_add=True)
#     updated_at = m.DateTimeField(auto_now=True)

# class CartItem(m.Model):
#     CART_ITEM_TYPES = (
#         ('listing', 'Listing'),
#         ('product', 'Product'),
#         ('package', 'Package'),
#     )
    
#     cart = m.ForeignKey(Cart, on_delete=m.CASCADE, related_name='items')
#     item_type = m.CharField(max_length=10, choices=CART_ITEM_TYPES)
#     item_id = m.PositiveIntegerField()
#     quantity = m.PositiveIntegerField(default=1)
#     added_at = m.DateTimeField(auto_now_add=True)

#     class Meta:
#         unique_together = ('cart', 'item_type', 'item_id')

# class Booking(m.Model):
#     STATUS_CHOICES = (
#         ('pending', 'Pending'),
#         ('confirmed', 'Confirmed'),
#         ('cancelled', 'Cancelled'),
#         ('completed', 'Completed'),
#     )
    
#     user = m.ForeignKey(User, on_delete=m.CASCADE)
#     listing = m.ForeignKey(Listing, on_delete=m.CASCADE, null=True, blank=True)
#     product = m.ForeignKey(Product, on_delete=m.CASCADE, null=True, blank=True)
#     package = m.ForeignKey(Packages, on_delete=m.CASCADE, null=True, blank=True)
#     booking_date = m.DateTimeField()
#     status = m.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
#     created_at = m.DateTimeField(auto_now_add=True)
#     payment_amount = m.DecimalField(max_digits=10, decimal_places=2)
#     payment_status = m.CharField(max_length=20, default='pending')
#     additional_info = m.JSONField(default=dict)
#     has_reviewed = m.BooleanField(default=False)

# class Order(m.Model):
#     user = m.ForeignKey(User, on_delete=m.CASCADE)
#     cart = m.ForeignKey(Cart, on_delete=m.SET_NULL, null=True)
#     total_amount = m.DecimalField(max_digits=10, decimal_places=2)
#     payment_status = m.CharField(max_length=20, default='pending')
#     status = m.CharField(max_length=20, default='processing')
#     created_at = m.DateTimeField(auto_now_add=True)
#     booking_info = m.JSONField(default=dict)  # Stores dates and other booking details

# class Transaction(m.Model):
#     id = m.AutoField(primary_key=True)
#     sender = m.ForeignKey(User, on_delete=m.CASCADE, null=True)
#     receiverf = m.ForeignKey(Freelancer, on_delete=m.CASCADE, null=True)
#     receiverb = m.ForeignKey(BusinessOwner, on_delete=m.CASCADE, null=True)
#     amount = m.IntegerField()
#     status = m.CharField(max_length=20, default='Completed')  # Updated to use consistent status
#     date = m.DateTimeField(auto_now_add=True)
#     package = m.ForeignKey(Packages, on_delete=m.CASCADE, null=True)
#     order = m.ForeignKey(Order, on_delete=m.SET_NULL, null=True, blank=True)  # Added order reference
#     booking = m.ForeignKey(Booking, on_delete=m.SET_NULL, null=True, blank=True)  # Added booking reference

# class BusinessTransaction(m.Model):
#     id = m.AutoField(primary_key=True)
#     type = m.TextField(blank=True)
#     date = m.DateTimeField(auto_now_add=True)
#     ownerf = m.ForeignKey(Freelancer, on_delete=m.CASCADE, null=True)
#     ownerb = m.ForeignKey(BusinessOwner, on_delete=m.CASCADE, null=True)
#     amount = m.IntegerField()
#     info = m.TextField()
#     status = m.CharField(max_length=20, default='Completed')  # Added status field
#     order = m.ForeignKey(Order, on_delete=m.SET_NULL, null=True, blank=True)  # Added order reference


# # models.py
# class Payment(m.Model):
#     STATUS_CHOICES = (
#         ('pending', 'Pending'),
#         ('completed', 'Completed'),
#         ('failed', 'Failed'),
#         ('refunded', 'Refunded'),
#     )
    
#     user = m.ForeignKey(User, on_delete=m.CASCADE)
#     order = m.ForeignKey(Order, on_delete=m.CASCADE, null=True, blank=True)
#     booking = m.ForeignKey(Booking, on_delete=m.CASCADE, null=True, blank=True)
#     amount = m.DecimalField(max_digits=10, decimal_places=2)
#     transaction_id = m.CharField(max_length=100, unique=True)
#     payment_method = m.CharField(max_length=50)
#     status = m.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
#     created_at = m.DateTimeField(auto_now_add=True)
#     updated_at = m.DateTimeField(auto_now=True)
#     payment_details = m.JSONField(default=dict)  
