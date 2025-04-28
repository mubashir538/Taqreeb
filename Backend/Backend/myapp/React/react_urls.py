from django.urls import path
from .react_api import ReactUserLogin, create_react_user
from rest_framework_simplejwt.views import TokenRefreshView

urlpatterns = [
    path('login/', ReactUserLogin, name='react_user_login'),
    path('token/refresh/', TokenRefreshView.as_view(), name='react_token_refresh'),
    path('users/create/', create_react_user, name='create_react_user'),
]