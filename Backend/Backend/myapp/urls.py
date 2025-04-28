from django.urls import path,include
from . import views
from .apis import Account_Management as am
from .apis import View_Pages as vp
from .apis import chats as c
from .apis import Invitation as i
from .apis import cart
from .apis import notifications as n
from .apis import Event_Management as em
from .apis import Payment as p
from .apis import Listing_Management as lm
from django.conf.urls.static import static
from django.conf import settings
from .apis import User_Activity as ua 
from .React import react_api as react
# from .apis import Event_Tracking as et  
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)
from .Serializers import CustomTokenObtainPairSerializer
from rest_framework.routers import DefaultRouter
from .React.react_api import ReactUserLogin, create_react_user


router = DefaultRouter()
router.register(r'cart', cart.CartViewSet, basename='cart')
router.register(r'cart/items', cart.CartItemViewSet, basename='cart-items')

urlpatterns = [
    # path('api/react/', include('myapp.react.react_urls')),
    
    path('profile/', react.react_user_profile, name='react_user_profile'),
    path('api/react/login/', react.ReactUserLogin, name='react_user_login'),
    path('api/react/token/refresh/', TokenRefreshView.as_view(), name='react_token_refresh'),
    path('api/react/users/create/', react.create_react_user, name='create_react_user'),
    path('unified_search/', lm.unified_search, name='unified_search'),
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
    path('basicUserInfo/<int:id>/',am.get_basic_userinfo,name='getBasicUserInfo'),
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
    path('home/packages/', lm.home_packages, name='home-packages'),
    path('home/products/', lm.home_products, name='home-products'),
    path('home/listings/views',lm.listing_with_views,name='ListingWithViews'),
    path('Payments/addTransaction',p.addTransaction,name='addTransaction'),
    path('create_order/',cart.create_order,name='create_order'),
    path('process_payment/',p.process_payment,name='process_payment'),
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
    path('user/bookings',cart.user_bookings,name='userBookings'),
    path('business/bookings',cart.business_bookings,name='business_bookings'),
    path('update_booking_status/',cart.update_booking_status,name='update_booking_status'),
    path('update_order_status/',p.update_order_status,name='update_order_status'),
    path('cancel_booking/',cart.cancel_booking,name='cancel_booking'),
    path('Reviews/MarkBooking',p.mark_booking_reviewed,name='mark_booking_reviewed'),
    path('health-check/',views.health_check,name='health-check'),
    path('Login/googleAuthentication',am.googleAuth,name='googleAuth'),
    path('deleteReq/',views.deleteTable,name='deleteReq'),
    path('', include(router.urls)),

]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)