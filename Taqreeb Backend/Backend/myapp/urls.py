from django.urls import path
from . import views

# import random Normal Import
# import random as rd Library Name change
# from random import randint import method from library

# print(randint(1,10))

urlpatterns = [
    path('userAccountSignup/',views.AccountSignupPage,name='userAccountSignup'),
    path('businessowner/signup/',views.BusinessOwnerSignup,name='BusinessOwnerSignup'),
    path('user/forgotpassword/phoneorEmail/',views.ForgotPasswordPage,name='ForgotPasswordPage'),
    path('user/forgotpassword/reset-password/',views.ResetPasswordPage,name='ResetPasswordPage'),
    path('accountInfo/',views.AccountInfoPage,name='AccountInfoPage'),
    path('businessowner/listings/<int:businessOwnerId>/',views.ListingsPage,name='ListingsPage'),
    path('decorator/detail/<int:listingId>/',views.DecoratorDetailPage,name='DecoratorDetailPage'),
    path('editaccountinfo/<int:userid>/',views.EditAccountInfoPage,name='EditAccountInfoPage'),
    path('freelancer/signup/',views.FreelancerSignup,name='FreelancerSignup'),
    path('createfunction/',views.CreateFunction,name='CreateFunction'),
    path('eventdetails/',views.EventDetails,name='EventDetails'),
    path('venueviewpage/ <int:listing id>',views.VenueViewPage,name='VenueViewPage'),
    path('CreateEvent/',views.CreateEvent,name='CreateEvent'),
    path('YourEvents/',views.YourEvents,name='YourEvents'),
    path('Photographer/viewpage/{listing id : int}',views.PhotographerViewPage,name='PhotographerViewPage'),
    path('Caterer/viewpage/{listing id : int}',views.CatererViewPage,name='CatererViewPage'),
    path('ViewFunction/',views.CatererViewPage,name='ViewFunction'),
    path('videoeditor/ {listing id : int}',views.VideoEditorViewPage,name='VideoEditorViewPage'),
    path('home/categories/',views.HomeCategories,name='HomeCategories'),
    path('home/listings/',views.HomeListings,name='HomeListings'),
    path('search/listings/{value:string}',views.SearchListings,name='SearchListings'),
    path('search/listings/{value:string}/{pricemin:int}',views.SearchListings,name='SearchListings'),
    path('show/guest/{event id : int}/{funtion id: int}',views.ShowGuest,name='ShowGuest'),
    path('add/guests/{event id: int}/{Funtioni d: int}',views.AddGuests,name='AddGuests'),
    path('businessowner/account-info/{businessOwnerId: int }',views.BusinessOwnerAccountInfo,name='BusinessOwnerAccountInfo'),
    path('User/login/',views.UserLogin,name='UserLogin'),
    path('cartItems/{product id: int}/{listing id: int}/{user id : int}',views.CartItems,name='CartItems'),
    path('graphic/designer/viewpage/{listing id: int}',views.GraphicDesignerViewPage,name='GraphicDesignerViewPage'),
    path('carrenter/viewpage/{listing id: int}',views.CarRenterViewPage,name='CarRenterViewPage'),
]