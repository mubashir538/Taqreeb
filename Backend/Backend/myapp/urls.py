from django.urls import path,include
from django.conf.urls.static import static
from django.conf import settings
from .React import react_api as react
from . import views
from .views import cart_views as cart
from .views import wishlist_views as wl
from .views import view_page_details as vp
from .views import user_profile_views as uaf
from .views import user_event_views as ue
from .views import user_auth_views as am
from .views import user_booking_views as ub
from .views import payment_views as p
from .views import tracking_views as uat
from .views import notification_views as nm
from .views import misc_views as mv
from .views import listing_views as lm
from .views import invitation_views as i
from .views import homepage_views as h
from .views import guest_views as gv
from .views import function_views as fv
from .views import event_views as em
from .views import checklist_views as cv
from .views import chat_views as ch
from .views import category_views as cat
from .views import business_views as b
from .views import activity_views as a
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)
from .Serializers import CustomTokenObtainPairSerializer
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register(r'cart', cart.CartViewSet, basename='cart')
router.register(r'cart/items', cart.CartItemViewSet, basename='cart-items')

urlpatterns = [
    
    path('profile/', react.react_user_profile, name='react_user_profile'),
    path('api/react/login/', react.ReactUserLogin, name='react_user_login'),
    path('api/react/token/refresh/', TokenRefreshView.as_view(), name='react_token_refresh'),
    path('api/react/users/create/', react.create_react_user, name='create_react_user'),
    path('unified_search/', lm.unified_search, name='unified_search'),
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'), 
    path('api/token/', TokenObtainPairView.as_view(serializer_class=CustomTokenObtainPairSerializer), name='token_obtain_pair'),
    path('resendOTP/phone',am.resendOTPPhone, name = 'resendOTPPhone'),
    path('notification/saveFCM',nm.saveFCMToken, name = 'saveFCMToken'),
    path('notification/DeleteFCM',nm.DeleteFCMToken, name = 'DeleteFCMToken'),
    path('notification/sendNotification',nm.send_notification, name = 'send_notification'),
    path('resendOTP/email',am.resendOTPEmail, name = 'resendOTPEmail'),
    path('resendOTP/forgot',am.resendOTP, name = 'resendOTP'),
    path('sendOTP/phone',am.sendOTPPhone,name='sendOTPPhone'), 
    path('sendOTP/email',am.sendOTPEmail,name='sendOTPEmail'),  
    path('userAccountSignup/',am.AccountSignupPage,name='userAccountSignup'),
    path('businessowner/signup/',b.BusinessOwnerSignup,name='BusinessOwnerSignup'),
    path('saveChatImage/',ch.saveChatImage,name='saveChatImage'),
    path('saveGroupImage/',ch.saveGroupImage,name='saveGroupImage'),
    path('saveGroupProfileImage/',ch.saveGroupProfile,name='saveGroupProfile'),
    path('user/forgotpassword/phoneorEmail/',am.ForgotPasswordPage,name='ForgotPasswordPage'),
    path('user/forgotpassword/reset-password/',am.ResetPasswordPage,name='ResetPasswordPage'),
    path('accountInfo/<int:id>/',uaf.AccountInfoPage,name='AccountInfoPage'),
    path('basicUserInfo/<int:id>/',uaf.get_basic_userinfo,name='getBasicUserInfo'),
    path('userChatInfo/<int:id>/',ch.getUserInfoChat,name='userChatInfo'),
    path('businessowner/listings/<int:id>/',lm.listings_page,name='ListingsPage'),
    path('businessowner/addListings/',lm.add_listing,name='AddListing'),
    path('businessowner/updateListings/',lm.updateListing,name='updateListings'),
    path('businessowner/DeleteListings/',lm.delete_listing,name='DeleteListings'),
    path('decorator/detail/<int:listingId>/',vp.DecoratorDetailPage,name='DecoratorDetailPage'),
    path('editaccountinfo/',uaf.EditAccountInfoPage,name='EditAccountInfoPage'),
    path('editBusinessInfo/',b.editBusinessInfo,name='editBusinessInfo'),
    path('freelancer/signup/',b.FreelancerSignup,name='FreelancerSignup'),
    path('searchType/<int:userid>',b.searchType,name='searchType'),
    path('createfunction/',fv.CreateFunction,name='CreateFunction'),
    path('getListingDetails/<str:type>',lm.get_listing_details,name='getListingDetails'),
    path('editfunction/',fv.EditFunction,name='EditFunction'),
    path('eventdetails/<int:eventId>',ue.EventDetails,name='EventDetails'),
    path('venueviewpage/<int:listingid>',vp.VenueViewPage,name='VenueViewPage'),
    path('CreateEvent/',ue.CreateEvent,name='CreateEvent'),
    path('EditEvent/',ue.EditEvent,name='EditEvent'),
    path('getEventTypes/',ue.getEventType,name='getEventType'),
    path('Invitation/CardDetails',i.getInvitationDetails,name='getInvitationDetails'),
    path('Invitation/Templates',i.getAvailableTemplates,name='getAvailableTemplates'),
    path('Events/getBasics/<int:id>',ue.getEventsAndFunctions,name='getEventsAndFunctions'),
    path('getFunctionTypes/<int:id>',h.getFunctionType,name='getFunctionType'),
    path('YourEvents/<int:id>',ue.YourEvents,name='YourEvents'),
    path('DeleteEvent/',ue.DeleteEvent,name='DeleteEvent'),
    path('DeleteFunction/',fv.DeleteFunction,name='DeleteFunction'),
    path('YourListing/<int:id>/<str:type>',lm.YourListings,name='YourListings'),
    path('YourEvents/functions/<int:id>',em.YourEventsandFunctions,name='YourEventsfunctions'),    
    path('Photographer/viewpage/<int:listingid>',vp.PhotographerViewPage,name='PhotographerViewPage'),
    path('PhotographyPlaces/viewpage/<int:listingid>',vp.PhotographyPlacesViewPage,name='PhotographyPlacesViewPage'),
    path('Caterer/viewpage/<int:listingid>',vp.CatererViewPage,name='CatererViewPage'),
    path('ViewFunction/<int:FunctionId>',fv.ViewFunction,name='ViewFunction'),
    path('error/application',uat.application_errors,name='error'),
    path('videoeditorviewpage/<int:listingid>',vp.VideoEditorViewPage,name='VideoEditorViewPage'),
    path('add/Bookcart/',cart.AddtoBookCart,name='AddtoBookCart'),
    path('show/Bookcart/<int:id>',cart.showBookCart,name='showBookCart'),
    path('saloonviewpage/<int:listingid>',vp.SalonViewPage,name='SaloonViewPage'),
    path('parlourviewpage/<int:listingid>',vp.ParlourViewPage,name='parlourViewPage'),
    path('home/categories/',cat.HomeCategories,name='HomeCategories'),
    path('business/categories/<str:type>',cat.BusinessCategories,name='BusinessCategories'),
    path('home/listings/',lm.HomeListings,name='HomeListings'),
    path('home/packages/', lm.home_packages, name='home-packages'),
    path('home/products/', lm.home_products, name='home-products'),
    path('home/listings/views',lm.listing_with_views,name='ListingWithViews'),
    path('Payments/addTransaction',p.addTransaction,name='addTransaction'),
    path('create_order/',ub.create_order,name='create_order'),
    path('process_payment/',p.process_payment,name='process_payment'),
    path('Payments/getWalletBalance/<int:id>/<str:type>',p.getWalletBalance,name='getWalletBalance'),
    path('Payments/WithdrawBalance',p.WithdrawBalance,name='WithdrawBalance'),
    path('Payments/getTransactions/<int:id>/<str:type>',p.getTransactions,name='getTransactions'),
    path('Payments/getTransactions/Recent/<int:id>/<str:type>',p.getTransactionsRecent,name='getTransactions'),
    path('Payments/addBank/',p.addBank,name='addBank'),
    path('Payments/getBank/<int:id>',p.getBank,name='getBank'),
    path('show/guest/',gv.ShowGuest,name='ShowGuest'),
    path('Delete/guest/',gv.DeleteGuest,name='DeleteGuest'),
    path('show/checklist/<int:eventId>',cv.ShowChecklist,name='ShowGuest'),
    path('show/checklist/<int:eventId>/<int:functionId>',cv.ShowChecklist,name='ShowGuest'),
    path('add/checklist',lm.add_list_item,name='AddChecklist'),
    path('update/checklist',lm.update_list_item,name='UpdateChecklist'),
    path('delete/checklist',lm.delete_list_item,name='DeleteChecklist'),
    path('add/guests/',gv.AddGuests,name='AddGuests'),
    path('businessowner/accountInfo/<int:id>/<str:type>',b.BusinessAccountInfoPage,name='BusinessOwnerAccountInfo'),
    path('User/login/',am.UserLogin,name='UserLogin'),
    path('getUsernames/business/',b.get_business_usernames,name='get_business_usernames'),
    path('Homepage/DemoImages/',h.getHomeImages,name='HomePageImages'),
    path('cartItems/<int:productid>/<int:listingid>/<int:userid>',cart.CartItems,name='CartItems'),
    path('graphic/designer/viewpage/<int:listingid>',vp.GraphicDesignerViewPage,name='GraphicDesignerViewPage'),
    path('carrenter/viewpage/<int:listingid>',vp.CarRenterViewPage,name='CarRenterViewPage'),
    path('log-user-activity/', a.log_user_activity, name='log-user-activity'),
    path('wishlist/add',wl.addtoWishlist,name='addtoWishlist'),
    path('wishlist/check',wl.checkWishlist,name='checkWishlist'),
    path('wishlist/get/<int:uid>',wl.getWishlist,name='getWishlist'),
    path('wishlist/delete',wl.removeFromWishlist,name='removeFromWishlist'),
    path('Reviews/add',vp.AddReview,name='addReview'),
    path('user/bookings',ub.user_bookings,name='userBookings'),
    path('business/bookings',ub.business_bookings,name='business_bookings'),
    path('update_booking_status/',ub.update_booking_status,name='update_booking_status'),
    path('update_order_status/',p.update_order_status,name='update_order_status'),
    path('cancel_booking/',ub.cancel_booking,name='cancel_booking'),
    path('Reviews/MarkBooking',p.mark_booking_reviewed,name='mark_booking_reviewed'),
    path('health-check/',mv.health_check,name='health-check'),
    path('Login/googleAuthentication',am.googleAuth,name='googleAuth'),
    path('deleteReq/',mv.deleteTable,name='deleteReq'),
    path('api/react/dashboard_most_searched/', react.dashboard_most_searched, name='dashboard_most_searched'),
    path('api/react/dashboard_most_used_services/', react.dashboard_most_used_services, name='dashboard_most_used_services'),
    path('api/react/dashboard_top_categories/', react.dashboard_top_categories, name='dashboard_top_categories'),
    path('api/react/dashboard_recent_activity/', react.dashboard_recent_activity, name='dashboard_recent_activity'),
    path('api/react/dashboard_top_search_terms/', react.dashboard_top_search_terms, name='dashboard_top_search_terms'),
    path('api/react/dashboard-statistics/', react.dashboard_statistics, name='dashboard_statistics'),
    path('api/approvals/stats/', react.pending_approvals_stats, name='pending-stats'),
    path('api/approvals/listings/', react.pending_listings, name='pending-listings'),
    path('api/approvals/listings/<int:pk>/', react.pending_listing_detail, name='pending-listing-detail'),
    path('api/approvals/listings/<int:pk>/status/', react.update_listing_status, name='update-listing-status'),
    path('api/approvals/bulk-status/', react.bulk_update_listing_status, name='bulk-update-status'),
    path('', include(router.urls)),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)