from django.db import models as m

class User(m.Model):
    id = m.AutoField(primary_key=True)
    firstName = m.CharField(max_length=100)
    lastName = m.CharField(max_length=100)
    password = m.CharField(max_length=100)
    contactNumber = m.CharField(max_length=15,null=True)
    email = m.CharField(max_length=50,null=True)
    city = m.CharField(max_length=50)
    gender = m.CharField(max_length=6)
    profilePicture = m.CharField(max_length=100)

class BusinessOwner(m.Model):
    id = m.AutoField(primary_key=True)
    cnic = m.TextField(null=True)
    userID = m.ForeignKey(User,on_delete=m.CASCADE)
    CNICFront = m.CharField(max_length=100)
    CNICBack = m.CharField(max_length=100)
    businessName = m.CharField(max_length=100)
    businessUsername = m.CharField(max_length=50)
    Description = m.CharField(max_length=1100)
    status = m.TextField(null=True)

class Freelancer(m.Model):
    id = m.AutoField(primary_key=True)
    userId = m.ForeignKey(User,on_delete=m.CASCADE)
    businessName = m.CharField(max_length=100)
    businessUsername = m.CharField(max_length=100)
    portfolioLink= m.CharField(max_length=100)
    description = m.CharField(max_length=1100)
    status = m.TextField(null=True)

class Listing(m.Model):
    id = m.AutoField(primary_key=True)
    ownerID = m.ForeignKey(BusinessOwner,on_delete=m.CASCADE)
    name = m.CharField(max_length=100)
    priceMin = m.IntegerField()
    priceMax = m.IntegerField() 
    location = m.CharField(max_length=100)
    description = m.CharField(max_length=1100)
    basicPrice = m.IntegerField()
    type = m.TextField(null=True)

class PicturesListings(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    picturePath = m.CharField(max_length=100)

class Packages(m.Model):
    id = m.AutoField(primary_key=True)
    type = m.IntegerField()
    name = m.CharField(max_length=100,default='Basic')
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    description = m.CharField(max_length=1100)
    price= m.IntegerField()

class Orders(m.Model):
    id = m.AutoField(primary_key=True)
    customerID = m.ForeignKey(User,on_delete=m.CASCADE)
    ownerID = m.ForeignKey(BusinessOwner,on_delete=m.CASCADE)
    ServiceID = m.ForeignKey(Listing,on_delete=m.CASCADE)
    price = m.IntegerField()
    packageID = m.ForeignKey(Packages,on_delete=m.CASCADE)
    slot = m.DateTimeField()
    status = m.CharField(max_length=100)

class AIEventQuestions(m.Model):
    id = m.AutoField(primary_key=True)
    question = m.CharField(max_length=100)
    questionType = m.CharField(max_length=50)

class QuestionOptions(m.Model):
    id = m.AutoField(primary_key=True)
    questionId = m.ForeignKey(AIEventQuestions,on_delete= m.CASCADE)
    optionType = m.TextField()
    name = m.TextField() 

class Freelancer(m.Model):
    id = m.AutoField(primary_key=True)
    userId = m.ForeignKey(User,on_delete=m.CASCADE)   
    businessUsername = m.CharField(max_length=100)
    portfolioLink = m.CharField(max_length=100)
    description = m.CharField(max_length=1100) 

class Events(m.Model):
    id = m.AutoField(primary_key=True)
    userID=  m.IntegerField()
    name =m.CharField(max_length=100)
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
    rating = m.DecimalField(max_digits=20,decimal_places=10)
    review = m.CharField(max_length=100)


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

# class Caterers(m.Model):
#     id = m.AutoField(primary_key=True)
#     listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
#     SERVICE_TYPE = []
#     CATERING_OPTIONS=[]
#     STAFF=[('Male','Male'),('Female','Female')]
#     EXPERTISE=[]
#     serviceType = m.CharField(max_length=100,choices=SERVICE_TYPE,default='Wedding')
#     cateringOptions = m.CharField(max_length=100,choices=CATERING_OPTIONS,default='Wedding')
#     staff = m.CharField(max_length=100,choices=STAFF,default='Wedding')
#     expertise = m.CharField(max_length=100,choices=EXPERTISE,default='Wedding')

class MenuItems(m.Model):                                                                                                                                                      
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE,null=True)
    name = m.CharField(max_length=100)
    pricePerKg = m.IntegerField()
    picture = m.CharField(max_length=100)

class Photographers(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    portfolioLink = m.CharField(max_length=100)

class Cart(m.Model):
    id = m.AutoField(primary_key=True)
    userId = m.ForeignKey(User,on_delete=m.CASCADE)
    productId = m.ForeignKey(MenuItems,on_delete=m.CASCADE)
    ownerId = m.ForeignKey(BusinessOwner,on_delete=m.CASCADE)
    quantity = m.IntegerField()

# class CarRenters(m.Model):
#     id = m.AutoField(primary_key=True)
#     listingID = m.ForeignKey(Listing,on_delete=m.CASCADE)
#     serviceType = m.CharField(max_length=100)
#     drivers = m.IntegerField()


# class Decorators(m.Model):
#     id = m.AutoField(primary_key=True)
#     listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
#     decorType = m.CharField(max_length=50)
#     catering = m.CharField(max_length=50)
#     staff = m.CharField(max_length=50)
#     slot = m.DateTimeField()

class Parlors(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    slot = m.DateTimeField()

class Salons(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    slot = m.CharField(max_length=100)

class BakersAndSweets(m.Model):
    id = m.AutoField(primary_key=True)
    listingID = m.ForeignKey(Listing,on_delete=m.CASCADE)

# class PhotographyPlaces(m.Model):
#     id = m.AutoField(primary_key=True)
#     listingID = m.ForeignKey(Listing,on_delete=m.CASCADE)
#     type = m.CharField(max_length=100)


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

class DesertItems(m.Model):
    id = m.AutoField(primary_key=True)
    name = m.CharField(max_length=255)
    bakersId = m.ForeignKey(BakersAndSweets,on_delete=m.CASCADE)
    price = m.IntegerField()
    type = m.CharField(max_length=100)
    description = m.CharField(max_length=500)
    picture = m.CharField(max_length=255)

class Categories(m.Model):
    id = m.AutoField(primary_key=True)
    name = m.CharField(max_length=255)
    picture = m.CharField(max_length=255)

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
    drivers = m.IntegerField()

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
    slot = m.DateTimeField()

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