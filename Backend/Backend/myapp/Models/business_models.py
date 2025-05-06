from django.db import models as m
from .user_models import User

class BusinessOwner(m.Model):
    id = m.AutoField(primary_key=True)
    cnic = m.TextField(blank=True)
    userID = m.ForeignKey(User,on_delete=m.CASCADE)
    CNICFront = m.CharField(max_length=100,blank=True)
    CNICBack = m.CharField(max_length=100,blank=True)
    businessName = m.CharField(max_length=100)
    profilepic = m.CharField(max_length=200,blank=True)
    Description = m.CharField(max_length=1100)
    status = m.TextField(blank=True)
    balance = m.IntegerField(default=0)

class Freelancer(m.Model):
    id = m.AutoField(primary_key=True)
    userID = m.ForeignKey(User,on_delete=m.CASCADE)
    businessName = m.CharField(max_length=100,blank=True)
    portfolioLink= m.CharField(max_length=100)
    cnic = m.CharField(max_length=50,blank=True)
    profilepic = m.CharField(max_length=100,blank=True)
    Description = m.CharField(max_length=1100)
    status = m.TextField(blank=True)
    balance = m.IntegerField(default=0)