from django.urls import path
from . import views
from django.conf.urls.static import static
from django.conf import settings

urlpatterns = [
    path('resendOTP/phone',views.resendOTPPhone, name = 'resendOTPPhone'),
    path('resendOTP/email',views.resendOTPEmail, name = 'resendOTPEmail'),
    path('sendOTP/phone',views.sendOTPPhone,name='sendOTPPhone'), 
    path('sendOTP/email',views.sendOTPEmail,name='sendOTPEmail'),  
    path('userAccountSignup/',views.AccountSignupPage,name='userAccountSignup'),
    path('businessowner/signup/',views.BusinessOwnerSignup,name='BusinessOwnerSignup'),
    path('user/forgotpassword/phoneorEmail/',views.ForgotPasswordPage,name='ForgotPasswordPage'),
    path('user/forgotpassword/reset-password/',views.ResetPasswordPage,name='ResetPasswordPage'),
    path('accountInfo/<int:id>',views.AccountInfoPage,name='AccountInfoPage'),
    path('businessowner/listings/<int:businessOwnerId>/',views.ListingsPage,name='ListingsPage'),
    path('decorator/detail/<int:listingId>/',views.DecoratorDetailPage,name='DecoratorDetailPage'),
    path('editaccountinfo/',views.EditAccountInfoPage,name='EditAccountInfoPage'),
    path('freelancer/signup/',views.FreelancerSignup,name='FreelancerSignup'),
    path('createfunction/',views.CreateFunction,name='CreateFunction'),
    path('editfunction/',views.EditFunction,name='EditFunction'),
    path('eventdetails/<int:eventId>',views.EventDetails,name='EventDetails'),
    path('venueviewpage/<int:listingid>',views.VenueViewPage,name='VenueViewPage'),
    path('CreateEvent/',views.CreateEvent,name='CreateEvent'),
    path('EditEvent/',views.EditEvent,name='EditEvent'),
    path('getEventTypes/',views.getEventType,name='getEventType'),
    path('getFunctionTypes/<int:id>',views.getFunctionType,name='getFunctionType'),
    path('YourEvents/<int:id>',views.YourEvents,name='YourEvents'),
    path('Photographer/viewpage/<int:listingid>',views.PhotographerViewPage,name='PhotographerViewPage'),
    path('PhotographyPlaces/viewpage/<int:listingid>',views.PhotographyPlacesViewPage,name='PhotographyPlacesViewPage'),
    path('Caterer/viewpage/<int:listingid>',views.CatererViewPage,name='CatererViewPage'),
    path('Bakers/viewpage/<int:listingid>',views.BakersViewPage,name='BakersViewPage'),
    path('ViewFunction/<int:FunctionId>',views.ViewFunction,name='ViewFunction'),
    path('videoeditorviewpage/<int:listingid>',views.VideoEditorViewPage,name='VideoEditorViewPage'),
    path('saloonviewpage/<int:listingid>',views.SalonViewPage,name='SaloonViewPage'),
    path('parlourviewpage/<int:listingid>',views.ParlourViewPage,name='parlourViewPage'),
    path('home/categories/',views.HomeCategories,name='HomeCategories'),
    path('home/listings/',views.HomeListings,name='HomeListings'),
    path('search/listings/<str:value>',views.SearchListings,name='SearchListings'),
    path('search/listings/<str:value>/<int:pricemin>',views.SearchListings,name='SearchListings'),
    path('show/guest/',views.ShowGuest,name='ShowGuest'),
    path('add/guests/',views.AddGuests,name='AddGuests'),
    path('businessowner/account-info/<int:businessOwnerId>',views.BusinessOwnerAccountInfo,name='BusinessOwnerAccountInfo'),
    path('User/login/',views.UserLogin,name='UserLogin'),
    path('cartItems/<int:productid>/<int:listingid>/<int:userid>',views.CartItems,name='CartItems'),
    path('graphic/designer/viewpage/<int:listingid>',views.GraphicDesignerViewPage,name='GraphicDesignerViewPage'),
    path('carrenter/viewpage/<int:listingid>',views.CarRenterViewPage,name='CarRenterViewPage'),
]


if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)