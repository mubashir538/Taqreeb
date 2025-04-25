from django.urls import path
from . import views
from .apis import Account_Management as am
from .apis import View_Pages as vp
from .apis import chats as c
from .apis import Invitation as i
from .apis import notifications as n
from .apis import Event_Management as em
from .apis import Payment as p
from .apis import Listing_Management as lm
from django.conf.urls.static import static
from django.conf import settings
from .apis import User_Activity as ua 
# from .apis import Event_Tracking as et  
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)
from .Serializers import CustomTokenObtainPairSerializer

urlpatterns = [
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'), 
    path('api/token/', TokenObtainPairView.as_view(serializer_class=CustomTokenObtainPairSerializer), name='token_obtain_pair'),
    path('resendOTP/phone',am.resendOTPPhone, name = 'resendOTPPhone'),
    path('notification/saveFCM',n.saveFCMToken, name = 'saveFCMToken'),
    path('notification/DeleteFCM',n.DeleteFCMToken, name = 'DeleteFCMToken'),
    path('notification/sendNotification',n.new_message, name = 'new_message'),
    path('resendOTP/email',am.resendOTPEmail, name = 'resendOTPEmail'),
    path('resendOTP/forgot',am.resendOTP, name = 'resendOTP'),
    path('sendOTP/phone',am.sendOTPPhone,name='sendOTPPhone'), 
    path('sendOTP/email',am.sendOTPEmail,name='sendOTPEmail'),  
    path('userAccountSignup/',am.AccountSignupPage,name='userAccountSignup'),
    path('businessowner/signup/',am.BusinessOwnerSignup,name='BusinessOwnerSignup'),
    path('saveChatImage/',c.saveChatImage,name='saveChatImage'),
    path('saveGroupImage/',c.saveGroupImage,name='saveGroupImage'),
    path('saveGroupProfileImage/',c.saveGroupProfile,name='saveGroupProfile'),
    path('user/forgotpassword/phoneorEmail/',am.ForgotPasswordPage,name='ForgotPasswordPage'),
    path('user/forgotpassword/reset-password/',am.ResetPasswordPage,name='ResetPasswordPage'),
    path('accountInfo/<int:id>/',am.AccountInfoPage,name='AccountInfoPage'),
    path('basicUserInfo/<int:id>/',am.getBasicUserInfo,name='getBasicUserInfo'),
    path('userChatInfo/<int:id>/',c.getUserInfoChat,name='userChatInfo'),
    path('businessowner/listings/<int:id>/',lm.listings_page,name='ListingsPage'),
    path('businessowner/addListings/',lm.add_listing,name='AddListing'),
    path('businessowner/updateListings/',lm.updateListing,name='updateListings'),
    path('businessowner/DeleteListings/',lm.delete_listing,name='DeleteListings'),
    path('decorator/detail/<int:listingId>/',vp.DecoratorDetailPage,name='DecoratorDetailPage'),
    path('editaccountinfo/',am.EditAccountInfoPage,name='EditAccountInfoPage'),
    path('editBusinessInfo/',am.editBusinessInfo,name='editBusinessInfo'),
    path('freelancer/signup/',am.FreelancerSignup,name='FreelancerSignup'),
    path('searchType/<int:userid>',views.searchType,name='searchType'),
    path('createfunction/',views.CreateFunction,name='CreateFunction'),
    path('getListingDetails/<str:type>',lm.get_listing_details,name='getListingDetails'),
    path('editfunction/',views.EditFunction,name='EditFunction'),
    path('eventdetails/<int:eventId>',em.EventDetails,name='EventDetails'),
    path('venueviewpage/<int:listingid>',vp.VenueViewPage,name='VenueViewPage'),
    path('CreateEvent/',em.CreateEvent,name='CreateEvent'),
    path('EditEvent/',em.EditEvent,name='EditEvent'),
    path('getEventTypes/',em.getEventType,name='getEventType'),
    path('Invitation/CardDetails',i.getInvitationDetails,name='getInvitationDetails'),
    path('Events/getBasics/<int:id>',em.getEventsAndFunctions,name='getEventsAndFunctions'),
    path('getFunctionTypes/<int:id>',views.getFunctionType,name='getFunctionType'),
    path('YourEvents/<int:id>',em.YourEvents,name='YourEvents'),
    path('DeleteEvent/',em.DeleteEvent,name='DeleteEvent'),
    path('DeleteFunction/',views.DeleteFunction,name='DeleteFunction'),
    path('YourListing/<int:id>/<str:type>',lm.YourListings,name='YourListings'),
    path('YourEvents/functions/<int:id>',views.YourEventsandFunctions,name='YourEventsfunctions'),    
    path('Photographer/viewpage/<int:listingid>',vp.PhotographerViewPage,name='PhotographerViewPage'),
    path('PhotographyPlaces/viewpage/<int:listingid>',vp.PhotographyPlacesViewPage,name='PhotographyPlacesViewPage'),
    path('Caterer/viewpage/<int:listingid>',vp.CatererViewPage,name='CatererViewPage'),
    path('Bakers/viewpage/<int:listingid>',vp.BakersViewPage,name='BakersViewPage'),
    path('ViewFunction/<int:FunctionId>',views.ViewFunction,name='ViewFunction'),
    path('error/application',views.application_errors,name='error'),
    path('videoeditorviewpage/<int:listingid>',vp.VideoEditorViewPage,name='VideoEditorViewPage'),
    path('add/Bookcart/',views.AddtoBookCart,name='AddtoBookCart'),
    path('show/Bookcart/<int:id>',views.showBookCart,name='showBookCart'),
    path('saloonviewpage/<int:listingid>',vp.SalonViewPage,name='SaloonViewPage'),
    path('parlourviewpage/<int:listingid>',vp.ParlourViewPage,name='parlourViewPage'),
    path('home/categories/',views.HomeCategories,name='HomeCategories'),
    path('business/categories/<str:type>',views.BusinessCategories,name='BusinessCategories'),
    path('home/listings/',lm.HomeListings,name='HomeListings'),
    path('home/listings/views',lm.ListingWithViews,name='ListingWithViews'),
    path('Payments/addTransaction',p.addTransaction,name='addTransaction'),
    path('Payments/getWalletBalance/<int:id>/<str:type>',p.getWalletBalance,name='getWalletBalance'),
    path('Payments/WithdrawBalance',p.WithdrawBalance,name='WithdrawBalance'),
    path('Payments/getTransactions/<int:id>/<str:type>',p.getTransactions,name='getTransactions'),
    path('Payments/getTransactions/Recent/<int:id>/<str:type>',p.getTransactions,name='getTransactions'),
    path('Payments/addBank',p.addBank,name='addBank'),
    path('Payments/getBank/<int:id>',p.getBank,name='getBank'),
    path('show/guest/',views.ShowGuest,name='ShowGuest'),
    path('Delete/guest/',views.DeleteGuest,name='DeleteGuest'),
    path('show/checklist/<int:eventId>',views.ShowChecklist,name='ShowGuest'),
    path('show/checklist/<int:eventId>/<int:functionId>',views.ShowChecklist,name='ShowGuest'),
    path('add/checklist',lm.add_list_item,name='AddChecklist'),
    path('update/checklist',lm.update_list_item,name='UpdateChecklist'),
    path('add/guests/',views.AddGuests,name='AddGuests'),
    path('businessowner/accountInfo/<int:id>/<str:type>',am.BusinessAccountInfoPage,name='BusinessOwnerAccountInfo'),
    path('User/login/',am.UserLogin,name='UserLogin'),
    path('getUsernames/business/',views.get_business_usernames,name='get_business_usernames'),
    path('Homepage/DemoImages/',views.getHomeImages,name='HomePageImages'),
    path('cartItems/<int:productid>/<int:listingid>/<int:userid>',views.CartItems,name='CartItems'),
    path('graphic/designer/viewpage/<int:listingid>',vp.GraphicDesignerViewPage,name='GraphicDesignerViewPage'),
    path('carrenter/viewpage/<int:listingid>',vp.CarRenterViewPage,name='CarRenterViewPage'),
    path('log-user-activity/', ua.log_user_activity, name='log-user-activity'),
    path('wishlist/add',views.addtoWishlist,name='addtoWishlist'),
    path('wishlist/get/<int:uid>',views.getWishlist,name='getWishlist'),
    path('wishlist/delete',views.removeFromWishlist,name='removeFromWishlist'),
    path('Reviews/add',vp.AddReview,name='addReview'),
    path('Login/googleAuthentication',am.googleAuth,name='googleAuth'),
    path('deleteReq/',views.deleteTable,name='deleteReq'),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)