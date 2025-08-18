from django.db import models as m
from .user_models import User

class Events(m.Model):
    id = m.AutoField(primary_key=True)
    name =m.CharField(max_length=100)
    userID =  m.ForeignKey(User,on_delete= m.CASCADE,null=True)
    type =m.CharField(max_length=100)
    date =m.CharField(max_length=100)
    location =m.CharField(max_length=100)
    description =m.CharField(max_length=1100)
    # themeColor =m.CharField(max_length=100)
    budget=  m.IntegerField()
    guestsmin = m.IntegerField(null=True)
    guestsmax = m.IntegerField(null=True) 

class Functions(m.Model):
    id = m.AutoField(primary_key=True)
    eventId = m.ForeignKey(Events, on_delete=m.CASCADE)
    name= m.CharField(max_length=100)
    budget = m.IntegerField()
    type = m.CharField(max_length=100)
    date = m.DateField(null=True)
    guestsmin = m.IntegerField(null=True)
    guestsmax = m.IntegerField(null=True)

class GuestList(m.Model):
    id = m.AutoField(primary_key=True)
    type = m.CharField(max_length=100)
    name = m.CharField(max_length=100)
    members = m.IntegerField(null=True)
    phone = m.CharField(max_length=100,blank=True)
    eventId = m.ForeignKey(Events,on_delete=m.CASCADE)
    functionId = m.ForeignKey(Functions,on_delete=m.CASCADE,null=True)


class CheckList(m.Model):
    id = m.AutoField(primary_key=True)
    description = m.CharField(max_length=1100)
    isChecked = m.BooleanField()
    functionId = m.ForeignKey(Functions,on_delete=m.CASCADE,null=True)
    eventId = m.ForeignKey(Events,on_delete=m.CASCADE)

class EventType(m.Model):
    id = m.AutoField(primary_key=True)
    name = m.CharField(max_length=100)

class FunctionType(m.Model):
    id = m.AutoField(primary_key=True)
    name = m.TextField()
    eventtypeid = m.ForeignKey(EventType,on_delete=m.CASCADE,null=True)