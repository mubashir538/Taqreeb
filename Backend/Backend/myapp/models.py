from django.db import models as m
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
import os
from django.contrib.auth.hashers import make_password, check_password


class CustomUserManager(BaseUserManager):
    def create_user(self, id, password=None, **extra_fields):
        """
        Create and return a regular user with an id and password.
        """
        if not id:
            raise ValueError('The ID field must be set')

        user = self.model(id=id, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, id, password=None, **extra_fields):
        """
        Create and return a superuser with an id and password.
        Superusers are created with `is_staff` and `is_superuser` set to True.
        """
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)

        return self.create_user(id, password, **extra_fields)

class User(AbstractBaseUser, PermissionsMixin):
    id = m.AutoField(primary_key=True)
    firstName = m.CharField(max_length=100)
    lastName = m.CharField(max_length=100)
    password = m.CharField(max_length=10000,null=True)
    contactNumber = m.CharField(max_length=15,null=True)
    email = m.CharField(max_length=50,null=True)
    city = m.CharField(max_length=50,null=True)
    username = m.CharField(max_length=50,null=True)
    age = m.IntegerField(null=True)
    gender = m.CharField(max_length=6,null=True)
    profilePicture = m.CharField(max_length=100)
    warning_reason = m.CharField(max_length=255, null=True, blank=True)
    warned_at = m.DateTimeField(null=True, blank=True)
    is_banned = m.BooleanField(default=False)
    objects = CustomUserManager()
    USERNAME_FIELD = 'id'
    REQUIRED_FIELDS = ['password', 'firstName', 'lastName', 'city', 'gender']
    def __str__(self):
        return str(self.id)

class TempInvitationCard(m.Model):
    file = m.ImageField(upload_to='uploads/tempCards/%Y/%m/%d/')
    created_at = m.DateTimeField(auto_now_add=True)
    def delete(self, *args, **kwargs):
        if self.file and os.path.isfile(self.file.path):
            os.remove(self.file.path)
        super().delete(*args, **kwargs)

class BusinessOwner(m.Model):
    id = m.AutoField(primary_key=True)
    cnic = m.TextField(null=True)
    userID = m.ForeignKey(User,on_delete=m.CASCADE)
    CNICFront = m.CharField(max_length=100,null=True)
    CNICBack = m.CharField(max_length=100,null=True)
    businessName = m.CharField(max_length=100)
    profilepic = m.CharField(max_length=200,null=True)
    Description = m.CharField(max_length=1100)
    status = m.TextField(null=True)
    balance = m.IntegerField(default=0)
class FCMTokens(m.Model):
    id = m.AutoField(primary_key=True)
    token = m.TextField()
    userid = m.ForeignKey(User,on_delete=m.CASCADE)

class Freelancer(m.Model):
    id = m.AutoField(primary_key=True)
    userID = m.ForeignKey(User,on_delete=m.CASCADE)
    businessName = m.CharField(max_length=100,null=True)
    portfolioLink= m.CharField(max_length=100)
    cnic = m.CharField(max_length=50,null=True)
    profilepic = m.CharField(max_length=100,null=True)
    Description = m.CharField(max_length=1100)
    status = m.TextField(null=True)
    balance = m.IntegerField(default=0)

class Listing(m.Model):
    id = m.AutoField(primary_key=True)
    ownerID = m.ForeignKey(BusinessOwner,on_delete=m.CASCADE,null=True)
    freelancerID = m.ForeignKey(Freelancer,on_delete=m.CASCADE,null=True)
    name = m.CharField(max_length=100)
    priceMin = m.IntegerField()
    priceMax = m.IntegerField() 
    location = m.CharField(max_length=100)
    description = m.CharField(max_length=1100)
    rating = m.DecimalField(max_digits=2, decimal_places=1,default=0)
    ratingCount = m.IntegerField(default=0)
    basicPrice = m.IntegerField()
    type = m.TextField(null=True)

class BusinessTransaction(m.Model):
    id = m.AutoField(primary_key=True)
    type = m.TextField(null=True)
    date = m.DateTimeField(auto_now_add=True)
    ownerf = m.ForeignKey(Freelancer,on_delete=m.CASCADE,null=True)
    ownerb = m.ForeignKey(BusinessOwner,on_delete=m.CASCADE,null=True)
    amount = m.IntegerField()
    info = m.TextField()

class BankDetails(m.Model):
    id = m.AutoField(primary_key=True)
    userID = m.ForeignKey(User,on_delete=m.CASCADE)
    bankName = m.TextField()
    accountNumber = m.TextField()
    IBANNumber = m.TextField()
    accountHolderName = m.TextField()

class PicturesListings(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    picturePath = m.CharField(max_length=100)

class Packages(m.Model):
    id = m.AutoField(primary_key=True)
    name = m.CharField(max_length=100,default='Basic')
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    description = m.CharField(max_length=1100)
    price= m.IntegerField()


# class Orders(m.Model):
#     id = m.AutoField(primary_key=True)
#     Transaction = m.ForeignKey(User,on_delete=m.CASCADE)
#     package = m.ForeignKey(Packages,delete=m.CASCADE)
#     receiverf = m.ForeignKey(Freelancer,on_delete=m.CASCADE,null=True)
#     receiverb = m.ForeignKey(BusinessOwner,on_delete=m.CASCADE,null=True)
#     date = m.DateTimeField(auto_now_add=True)

class Transaction(m.Model):
    id = m.AutoField(primary_key=True)
    sender = m.ForeignKey(User,on_delete=m.CASCADE,null=True)
    receiverf = m.ForeignKey(Freelancer,on_delete=m.CASCADE,null=True)
    receiverb = m.ForeignKey(BusinessOwner,on_delete=m.CASCADE,null=True)
    amount = m.IntegerField()
    status = m.TextField(null=True)
    date = m.DateTimeField(auto_now_add=True)
    package = m.ForeignKey(Packages,on_delete=m.CASCADE,null=True)

class PicturesPackages(m.Model):
    id = m.AutoField(primary_key=True)
    packageId = m.ForeignKey(Packages,on_delete=m.CASCADE)
    picturePath = m.CharField(max_length=100)

class AIEventQuestions(m.Model):
    id = m.AutoField(primary_key=True)
    question = m.CharField(max_length=100)
    questionType = m.CharField(max_length=50)

class QuestionOptions(m.Model):
    id = m.AutoField(primary_key=True)
    questionId = m.ForeignKey(AIEventQuestions,on_delete= m.CASCADE)
    optionType = m.TextField()
    name = m.TextField() 

class Events(m.Model):
    id = m.AutoField(primary_key=True)
    name =m.CharField(max_length=100)
    userID =  m.ForeignKey(User,on_delete= m.CASCADE,null=True)
    type =m.CharField(max_length=100)
    date =m.CharField(max_length=100)
    location =m.CharField(max_length=100)
    description =m.CharField(max_length=1100)
    themeColor =m.CharField(max_length=100)
    budget=  m.IntegerField()
    guestsmin = m.IntegerField(null=True)
    guestsmax = m.IntegerField(null=True) 

class GuestList(m.Model):
    id = m.AutoField(primary_key=True)
    type = m.CharField(max_length=100)
    name = m.CharField(max_length=100)
    members = m.IntegerField(null=True)
    phone = m.CharField(max_length=100,null=True)
    eventId = m.ForeignKey(Events,on_delete=m.CASCADE)
    functionId = m.IntegerField(null=True)

class Review(m.Model):
    id = m.AutoField(primary_key=True)
    listingID = m.ForeignKey(Listing,on_delete=m.CASCADE)
    userID = m.ForeignKey(User,on_delete=m.CASCADE)
    rating = m.DecimalField(max_digits=2, decimal_places=1)
    review = m.CharField(max_length=100)
    date = m.DateTimeField(auto_now_add=True,null=True)

class ReviewDetails(m.Model):
    id = m.AutoField(primary_key=True)
    listingID = m.ForeignKey(Listing,on_delete=m.CASCADE)
    s5 = m.IntegerField(default=0)
    s4 = m.IntegerField(default=0)
    s3 = m.IntegerField(default=0)
    s2 = m.IntegerField(default=0)
    s1 = m.IntegerField(default=0)

class Functions(m.Model):
    id = m.AutoField(primary_key=True)
    eventId = m.ForeignKey(Events, on_delete=m.CASCADE)
    name= m.CharField(max_length=100)
    budget = m.IntegerField()
    type = m.CharField(max_length=100)
    date = m.DateField(null=True)
    guestsmin = m.IntegerField(null=True)
    guestsmax = m.IntegerField(null=True)

class CheckList(m.Model):
    id = m.AutoField(primary_key=True)
    description = m.CharField(max_length=1100)
    isChecked = m.BooleanField()
    functionId = m.ForeignKey(Functions,on_delete=m.CASCADE,null=True)
    eventId = m.ForeignKey(Events,on_delete=m.CASCADE)

class AddOns(m.Model):
    id = m.AutoField(primary_key=True)
    name = m.CharField(max_length=255)
    price = m.IntegerField()
    isPer = m.BooleanField()
    perType = m.CharField(max_length=50)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)

class MenuItems(m.Model):                                                                                                                                                      
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE,null=True)
    name = m.CharField(max_length=100)
    pricePerKg = m.IntegerField()
    picture = m.CharField(max_length=100)

class Cart(m.Model):
    id = m.AutoField(primary_key=True)
    userId = m.ForeignKey(User,on_delete=m.CASCADE)
    productId = m.ForeignKey(MenuItems,on_delete=m.CASCADE)
    ownerId = m.ForeignKey(BusinessOwner,on_delete=m.CASCADE)
    quantity = m.IntegerField()
    
    
class Parlors(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)

class Salons(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)

class Photographers(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    portfolioLink = m.CharField(max_length=100)

class VideoEditors(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    portfolioLink = m.TextField()

class GraphicDesigners(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    portfolioLink = m.CharField(max_length=100)

class EventType(m.Model):
    id = m.AutoField(primary_key=True)
    name = m.CharField(max_length=100)

class FunctionType(m.Model):
    id = m.AutoField(primary_key=True)
    name = m.TextField()
    eventtypeid = m.ForeignKey(EventType,on_delete=m.CASCADE,null=True)

class Wishlist(m.Model):
    id = m.AutoField(primary_key=True)
    user = m.ForeignKey(User,on_delete=m.CASCADE)
    listing = m.ForeignKey(Listing,on_delete=m.CASCADE)

class Categories(m.Model):
    id = m.AutoField(primary_key=True)
    name = m.CharField(max_length=255)
    picture = m.CharField(max_length=255)
    type = m.CharField(max_length=100,default='business')

class Venue(m.Model):
    id = m.AutoField(primary_key=True)
    listingID = m.ForeignKey('Listing', on_delete=m.CASCADE)
    VENUE_TYPE_CHOICES = [
        ('Banquet', 'Banquet'),
        ('Hall', 'Hall'),
        ('Lawn', 'Lawn'),
        ('Outdoor', 'Outdoor'),
    ]
    venueType = m.CharField(
        max_length=50,
        choices=VENUE_TYPE_CHOICES,
        default='Banquet'
    )
    CATERING_CHOICES = [
        ('Internal', 'Internal'),
        ('External', 'External'),
        ('Internal & External', 'Internal & External'),
    ]
    catering = m.CharField(
        max_length=50,
        choices=CATERING_CHOICES,
        default='Internal'
    )

    # Choices for staff
    STAFF_CHOICES = [
        ('Male', 'Male'),
        ('Female', 'Female'),
    ]
    staff = m.CharField(
        max_length=10,
        choices=STAFF_CHOICES,
        default='Male'
    )
    guestminAllowed = m.IntegerField(default=0)
    guestmaxAllowed = m.IntegerField(default=0)

    def __str__(self):
        return f"{self.listingID} - {self.venueType}"

class BookedSlots(m.Model):
    id = m.AutoField(primary_key=True)
    slot = m.DateField()
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)

class BookingCart(m.Model):
    id = m.AutoField(primary_key=True)
    userId = m.ForeignKey(User,on_delete=m.CASCADE)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    functionId = m.ForeignKey(Functions,on_delete=m.CASCADE,null=True)
    slot = m.DateTimeField(null=True)
    type = m.CharField(max_length=100,null=True)
    status = m.CharField(max_length=100)

class HomePageImages(m.Model):
    id = m.AutoField(primary_key=True)
    image = m.CharField(max_length=255)

class Caterers(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing, on_delete=m.CASCADE)

    SERVICE_TYPE_CHOICES = [
        ('Wedding', 'Wedding'),
        ('Corporate', 'Corporate'),
        ('Birthday', 'Birthday'),
        ('Anniversary', 'Anniversary'),
        ('Other', 'Other'),
    ]
    CATERING_OPTIONS_CHOICES = [
        ('Buffet', 'Buffet'),
        ('Plated', 'Plated'),
        ('Family Style', 'Family Style'),
        ('Food Stations', 'Food Stations'),
        ('Cocktail Reception', 'Cocktail Reception'),
    ]
    STAFF_CHOICES = [
        ('Male', 'Male'),
        ('Female', 'Female'),
        ('Mixed', 'Mixed'),
    ]
    EXPERTISE_CHOICES = [
        ('Pakistani', 'Pakistani'),
        ('Chinese', 'Chinese'),
        ('Continental', 'Continental'),
        ('Italian', 'Italian'),
        ('Desserts', 'Desserts'),
    ]

    serviceType = m.CharField(max_length=100, choices=SERVICE_TYPE_CHOICES, default='Wedding')
    cateringOptions = m.CharField(max_length=100, choices=CATERING_OPTIONS_CHOICES, default='Buffet')
    staff = m.CharField(max_length=100, choices=STAFF_CHOICES, default='Mixed')
    expertise = m.CharField(max_length=100, choices=EXPERTISE_CHOICES, default='Pakistani')

class CarRenters(m.Model):
    id = m.AutoField(primary_key=True)
    listingID = m.ForeignKey(Listing, on_delete=m.CASCADE)
    SERVICE_TYPE_CHOICES = [
        ('Luxury', 'Luxury'),
        ('Economy', 'Economy'),
        ('SUV', 'SUV'),
        ('Convertible', 'Convertible'),
        ('Van', 'Van'),
    ]
    serviceType = m.CharField(max_length=100, choices=SERVICE_TYPE_CHOICES, default='Economy')

class Decorators(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing, on_delete=m.CASCADE)

    DECOR_TYPE_CHOICES = [
        ('Floral', 'Floral'),
        ('Lighting', 'Lighting'),
        ('Drapery', 'Drapery'),
        ('Furniture', 'Furniture'),
        ('Themed', 'Themed'),
    ]
    CATERING_CHOICES = [
        ('Provided', 'Provided'),
        ('Not Provided', 'Not Provided'),
    ]
    STAFF_CHOICES = [
        ('Male', 'Male'),
        ('Female', 'Female'),
        ('Mixed', 'Mixed'),
    ]

    decorType = m.CharField(max_length=50, choices=DECOR_TYPE_CHOICES, default='Floral')
    catering = m.CharField(max_length=50, choices=CATERING_CHOICES, default='Not Provided')
    staff = m.CharField(max_length=50, choices=STAFF_CHOICES, default='Mixed')

class PhotographyPlaces(m.Model):
    id = m.AutoField(primary_key=True)
    listingID = m.ForeignKey(Listing, on_delete=m.CASCADE)

    TYPE_CHOICES = [
        ('Studio', 'Studio'),
        ('Outdoor', 'Outdoor'),
        ('Indoor', 'Indoor'),
        ('Destination', 'Destination'),
        ('Event', 'Event'),
    ]

    type = m.CharField(max_length=100, choices=TYPE_CHOICES, default='Studio')

class Cars(m.Model):
    id = m.AutoField(primary_key=True)
    carRenterId = m.ForeignKey(CarRenters,on_delete=m.CASCADE)
    pricePerDay = m.IntegerField()
    name = m.CharField(max_length=255)
    type = m.CharField(max_length=100)
    seats = m.IntegerField()
    driver = m.IntegerField()
    picture = m.CharField(max_length=255)

class UserActivity(m.Model):
    ACTIONS = [
        ('search', 'Search Query'),
        ('category_click', 'Clicked Category'),
        ('service_click', 'Clicked Service'),
        ('filter', 'Applied Filter'),
        ('event_create', 'Created Event'),
        ('event_edit', 'Edited Event'),
        ('event_view', 'Viewed Event'),
        ('invite_card_view', 'Viewed Invitation Card'),
        ('service_view_duration', 'Time Spent on Service Page'),
        ('category_view_duration', 'Time Spent on Category Page'),
        ('book_venue', 'Booked Venue'),  # ✅ NEW ACTION ADDED
        ('homepage_view_duration', 'Time Spent on Home Page'),
        ('ai_package_button_click', 'AI Package Button Clicked'),
        ('user_register', 'User Registered'),
    ]
    user = m.ForeignKey(User, on_delete=m.CASCADE)
    action = m.CharField(max_length=50, choices=ACTIONS)
    metadata = m.JSONField(null=True, blank=True)
    timestamp = m.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.action} - {self.timestamp}"


class UserManager(BaseUserManager):
    def create_user(self, username, name, email, password=None):
        if not email:
            raise ValueError("Users must have an email address")
        email = self.normalize_email(email)
        user = self.model(username=username, name=name, email=email)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, username, name, email, password):
        user = self.create_user(username, name, email, password)
        user.is_staff = True
        user.is_superuser = True
        user.save(using=self._db)
        return user

