from django.urls import path
from . import views

# import random Normal Import
# import random as rd Library Name change
# from random import randint import method from library

# print(randint(1,10))

urlpatterns = [
    path('home/',views.home,name='home'),
    path('Login/',views.login,name='login'),
    path('signup/', views.signup, name='signup'),
]