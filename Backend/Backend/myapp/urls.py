from django.urls import path,include
from django.conf.urls.static import static
from django.conf import settings
from .React import react_api as react
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
from .views import chat_bot_views as chatbot
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)
from .Serializers.token_serializers import CustomTokenObtainPairSerializer
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register(r'cart', cart.CartViewSet, basename='cart')
router.register(r'cart/items', cart.CartItemViewSet, basename='cart-items')

urlpatterns = [
    path('Login/googleAuthentication', am.google_auth, name='googleAuth'),
path('resendOTP/email', am.resend_otp_email, name='resendOTPEmail'),
path('resendOTP/forgot', am.resend_otp, name='resendOTP'),
path('resendOTP/phone', am.resend_otp_phone, name='resendOTPPhone'),
path('sendOTP/email', am.send_otp_email, name='sendOTPEmail'),
path('sendOTP/phone', am.send_otp_phone, name='sendOTPPhone'),
path('User/login/', am.user_login, name='UserLogin'),
path('user/forgotpassword/phoneorEmail/', am.forgot_password_page, name='ForgotPasswordPage'),
path('user/forgotpassword/reset-password/', am.reset_password_page, name='ResetPasswordPage'),
path('userAccountSignup/', am.account_signup_page, name='userAccountSignup'),
path('log-user-activity/', a.log_user_activity, name='log-user-activity'),
path('business/categories/[str:type](str:type)', cat.business_categories, name='BusinessCategories'),
path('business/bookings', ub.business_bookings, name='business_bookings'),
path('businessowner/accountInfo/[int:id](int:id)/[str:type](str:type)', b.business_account_info_page, name='BusinessOwnerAccountInfo'),
path('businessowner/addListings/', lm.add_listing, name='AddListing'),
path('businessowner/DeleteListings/', lm.delete_listing, name='DeleteListings'),
path('businessowner/listings/[int:id](int:id)/', lm.listings_page, name='ListingsPage'),
path('businessowner/signup/', b.business_owner_signup, name='BusinessOwnerSignup'),
path('businessowner/updateListings/', lm.update_listing_fields, name='updateListings'),
path('editBusinessInfo/', b.edit_business_info, name='editBusinessInfo'),
path('freelancer/signup/', b.freelancer_signup, name='FreelancerSignup'),
path('getUsernames/business/', b.get_business_usernames, name='get_business_usernames'),
path('searchType/[int:userid](int:userid)', b.search_type, name='searchType'),
path('add/Bookcart/', cart.add_to_book_cart, name='AddtoBookCart'),
path('cartItems/[int:productid](int:productid)/[int:listingid](int:listingid)/[int:userid](int:userid)', cart.cart_items, name='CartItems'),
path('show/Bookcart/[int:id](int:id)', cart.show_book_cart, name='showBookCart'),
path('home/categories/', cat.home_categories, name='HomeCategories'),
path('saveChatImage/', ch.save_chat_image, name='saveChatImage'),
path('saveGroupImage/', ch.savegroupimage, name='saveGroupImage'),
path('saveGroupProfileImage/', ch.savegroupprofile, name='saveGroupProfile'),
path('userChatInfo/[int:id](int:id)/', ch.getuserinfochat, name='userChatInfo'),
path('api/chatbot/', chatbot.chatbot_api, name='chatbot_api'),
path('show/checklist/[int:eventId](int:eventId)', cv.showchecklist, name='ShowGuest'),
path('show/checklist/[int:eventId](int:eventId)/[int:functionId](int:functionId)', cv.showchecklist, name='ShowGuest'),
path('YourEvents/functions/[int:id](int:id)', em.youreventsandfunctions, name='YourEventsfunctions'),
path('createfunction/', fv.createfunction, name='CreateFunction'),
path('DeleteFunction/', fv.deletefunction, name='DeleteFunction'),
path('editfunction/', fv.editfunction, name='EditFunction'),
path('ViewFunction/[int:FunctionId](int:FunctionId)', fv.viewfunction, name='ViewFunction'),
path('add/guests/', gv.add_guests, name='AddGuests'),
path('Delete/guest/', gv.delete_guest, name='DeleteGuest'),
path('show/guest/', gv.show_guest, name='ShowGuest'),
path('getFunctionTypes/[int:id](int:id)', h.get_function_type, name='getFunctionType'),
path('Homepage/DemoImages/', h.get_home_images, name='HomePageImages'),
path('Invitation/CardDetails', i.get_invitation_details, name='getInvitationDetails'),
path('Invitation/Templates', i.get_available_templates, name='getAvailableTemplates'),
path('add/checklist', lm.add_list_item, name='AddChecklist'),
path('delete/checklist', lm.delete_list_item, name='DeleteChecklist'),
path('getListingDetails/[str:type](str:type)', lm.get_listing_details, name='getListingDetails'),
path('home/listings/', lm.home_listings, name='HomeListings'),
path('home/listings/views', lm.listing_with_views, name='ListingWithViews'),
path('home/packages/', lm.home_packages, name='home-packages'),
path('home/products/', lm.home_products, name='home-products'),
path('unified_search/', lm.unified_search, name='unified_search'),
path('update/checklist', lm.update_list_item, name='UpdateChecklist'),
path('YourListing/[int:id](int:id)/[str:type](str:type)', lm.your_listings, name='YourListings'),
path('deleteReq/', mv.delete_table, name='deleteReq'),
path('health-check/', mv.health_check, name='health-check'),
path('notification/DeleteFCM', nm.delete_fcm_token, name='DeleteFCMToken'),
path('notification/saveFCM', nm.save_fcm_token, name='saveFCMToken'),
path('notification/sendNotification', nm.send_notification, name='send_notification'),
path('Payments/addBank/', p.add_bank, name='addBank'),
path('Payments/addTransaction', p.add_transaction, name='addTransaction'),
path('Payments/getBank/[int:id](int:id)', p.get_bank, name='getBank'),
path('Payments/getTransactions/[int:id](int:id)/[str:type](str:type)', p.get_transactions, name='getTransactions'),
path('Payments/getTransactions/Recent/[int:id](int:id)/[str:type](str:type)', p.get_transactions_recent, name='getTransactions'),
path('Payments/getWalletBalance/[int:id](int:id)/[str:type](str:type)', p.get_wallet_balance, name='getWalletBalance'),
path('Payments/WithdrawBalance', p.withdraw_balance, name='WithdrawBalance'),
path('Reviews/MarkBooking', p.mark_booking_reviewed, name='mark_booking_reviewed'),
path('process_payment/', p.process_payment, name='process_payment'),
path('update_order_status/', p.update_order_status, name='update_order_status'),
path('api/react/dashboard-statistics/', react.dashboard_statistics, name='dashboard_statistics'),
path('api/react/dashboard_most_searched/', react.dashboard_most_searched, name='dashboard_most_searched'),
path('api/react/dashboard_most_used_services/', react.dashboard_most_used_services, name='dashboard_most_used_services'),
path('api/react/dashboard_recent_activity/', react.dashboard_recent_activity, name='dashboard_recent_activity'),
path('api/react/dashboard_top_categories/', react.dashboard_top_categories, name='dashboard_top_categories'),
path('api/react/dashboard_top_search_terms/', react.dashboard_top_search_terms, name='dashboard_top_search_terms'),
path('api/react/login/', react.ReactUserLogin, name='react_user_login'),
path('api/react/token/refresh/', TokenRefreshView.as_view(), name='react_token_refresh'),
path('api/react/users/create/', react.create_react_user, name='create_react_user'),
path('profile/', react.react_user_profile, name='react_user_profile'),
path('accountInfo/[int:id](int:id)/', uaf.account_info_page, name='AccountInfoPage'),
path('basicUserInfo/[int:id](int:id)/', uaf.get_basic_userinfo, name='getBasicUserInfo'),
path('editaccountinfo/', uaf.edit_account_info_page, name='EditAccountInfoPage'),
path('error/application', uat.application_errors, name='error'),
path('cancel_booking/', ub.cancel_booking, name='cancel_booking'),
path('create_order/', ub.create_order, name='create_order'),
path('update_booking_status/', ub.update_booking_status, name='update_booking_status'),
path('user/bookings', ub.user_bookings, name='userBookings'),
path('CreateEvent/', ue.create_event, name='CreateEvent'),
path('DeleteEvent/', ue.delete_event, name='DeleteEvent'),
path('EditEvent/', ue.edit_event, name='EditEvent'),
path('Events/getBasics/[int:id](int:id)', ue.get_events_and_functions, name='getEventsAndFunctions'),
path('eventdetails/[int:eventId](int:eventId)', ue.event_details, name='EventDetails'),
path('getEventTypes/', ue.get_event_type, name='getEventType'),
path('YourEvents/[int:id](int:id)', ue.your_events, name='YourEvents'),
path('Caterer/viewpage/[int:listingid](int:listingid)', vp.caterer_view_page, name='CatererViewPage'),
path('Photographer/viewpage/[int:listingid](int:listingid)', vp.photographer_view_page, name='PhotographerViewPage'),
path('PhotographyPlaces/viewpage/[int:listingid](int:listingid)', vp.photography_places_view_page, name='PhotographyPlacesViewPage'),
path('Reviews/add', vp.add_review, name='addReview'),
path('carrenter/viewpage/[int:listingid](int:listingid)', vp.car_renter_view_page, name='CarRenterViewPage'),
path('decorator/detail/[int:listingId](int:listingId)/', vp.decorator_detail_page, name='DecoratorDetailPage'),
path('graphic/designer/viewpage/[int:listingid](int:listingid)', vp.graphic_designer_view_page, name='GraphicDesignerViewPage'),
path('parlourviewpage/[int:listingid](int:listingid)', vp.parlour_view_page, name='parlourViewPage'),
path('saloonviewpage/[int:listingid](int:listingid)', vp.salon_view_page, name='SaloonViewPage'),
path('venueviewpage/[int:listingid](int:listingid)', vp.venue_view_page, name='VenueViewPage'),
path('videoeditorviewpage/[int:listingid](int:listingid)', vp.video_editor_view_page, name='VideoEditorViewPage'),
path('wishlist/add', wl.add_to_wishlist, name='addtoWishlist'),
path('wishlist/check', wl.check_wishlist, name='checkWishlist'),
path('wishlist/delete', wl.remove_from_wishlist, name='removeFromWishlist'),
path('wishlist/get/[int:uid](int:uid)', wl.get_wishlist, name='getWishlist'),
path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
path('api/token/', TokenObtainPairView.as_view(serializer_class=CustomTokenObtainPairSerializer), name='token_obtain_pair'),
path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
path('api/approvals/bulk-status/', react.bulk_update_listing_status, name='bulk-update-status'),
path('api/approvals/listings/', react.pending_listings, name='pending-listings'),
path('api/approvals/listings/[int:pk](int:pk)/', react.pending_listing_detail, name='pending-listing-detail'),
path('api/approvals/listings/[int:pk](int:pk)/status/', react.update_listing_status, name='update-listing-status'),
path('api/approvals/stats/', react.pending_approvals_stats, name='pending-stats'),
path('', include(router.urls)),
]
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)