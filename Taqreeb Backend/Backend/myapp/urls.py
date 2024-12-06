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
    path('accountInfo/<int:id>',views.AccountInfoPage,name='AccountInfoPage'),
    path('businessowner/listings/<int:businessOwnerId>/',views.ListingsPage,name='ListingsPage'),
    path('decorator/detail/<int:listingId>/',views.DecoratorDetailPage,name='DecoratorDetailPage'),
    path('editaccountinfo/<int:userid>/',views.EditAccountInfoPage,name='EditAccountInfoPage'),
    path('freelancer/signup/',views.FreelancerSignup,name='FreelancerSignup'),
    path('createfunction/',views.CreateFunction,name='CreateFunction'),
    path('eventdetails/<int:eventId>',views.EventDetails,name='EventDetails'),
    path('venueviewpage/<int:listingid>',views.VenueViewPage,name='VenueViewPage'),
    path('CreateEvent/',views.CreateEvent,name='CreateEvent'),
    path('YourEvents/',views.YourEvents,name='YourEvents'),
    path('Photographer/viewpage/<int:listingid>',views.PhotographerViewPage,name='PhotographerViewPage'),
    path('Caterer/viewpage/<int:listingid>',views.CatererViewPage,name='CatererViewPage'),
    path('ViewFunction/',views.ViewFunction,name='ViewFunction'),
    path('videoeditorviewpage/<int:listingid>',views.VideoEditorViewPage,name='VideoEditorViewPage'),
    path('saloonviewpage/<int:listingid>',views.VideoEditorViewPage,name='SaloonViewPage'),
    path('home/categories/',views.HomeCategories,name='HomeCategories'),
    path('home/listings/',views.HomeListings,name='HomeListings'),
    path('search/listings/<str:value>',views.SearchListings,name='SearchListings'),
    path('search/listings/<str:value>/<int:pricemin>',views.SearchListings,name='SearchListings'),
    path('show/guest/<int:eventid>/<int:funtionid>',views.ShowGuest,name='ShowGuest'),
    path('add/guests/<int:eventid>/<int:Funtionid>',views.AddGuests,name='AddGuests'),
    path('businessowner/account-info/<int:businessOwnerId>',views.BusinessOwnerAccountInfo,name='BusinessOwnerAccountInfo'),
    path('User/login/',views.UserLogin,name='UserLogin'),
    path('cartItems/<int:productid>/<int:listingid>/<int:userid>',views.CartItems,name='CartItems'),
    path('graphic/designer/viewpage/<int:listingid>',views.GraphicDesignerViewPage,name='GraphicDesignerViewPage'),
    path('carrenter/viewpage/<int:listingid>',views.CarRenterViewPage,name='CarRenterViewPage'),
]