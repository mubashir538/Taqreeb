from django.db import models as m
# from .user_models import User
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin

class CustomUserManager(BaseUserManager):
    def create_user(self, id, password=None, **extra_fields):
        """
        Create and return a regular user with an id and password.
        """
        if not id:
            raise ValueError('The ID field must be set')

        user = self.model(id=id, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, id, password=None, **extra_fields):
        """
        Create and return a superuser with an id and password.
        Superusers are created with `is_staff` and `is_superuser` set to True.
        """
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)

        return self.create_user(id, password, **extra_fields)
    
class User(AbstractBaseUser, PermissionsMixin):
    id = m.AutoField(primary_key=True)
    firstName = m.CharField(max_length=100)
    lastName = m.CharField(max_length=100)
    password = m.CharField(max_length=10000,null=True)
    contactNumber = m.CharField(max_length=15,null=True)
    email = m.CharField(max_length=50,null=True)
    city = m.CharField(max_length=50,null=True)
    username = m.CharField(max_length=50,null=True)
    age = m.IntegerField(null=True)
    gender = m.CharField(max_length=6,null=True)
    date_joined = m.DateTimeField(auto_now_add=True, null=True)

    USERNAME_FIELD = 'id'
    REQUIRED_FIELDS = ['password', 'firstName', 'lastName', 'city', 'gender']
    def __str__(self):
        return str(self.id)
    groups = m.ManyToManyField(
        'auth.Group',
        verbose_name='groups',
        blank=True,
        help_text='The groups this user belongs to.',
        related_name="flutter_user_set",
        related_query_name="flutter_user",
    )
    user_permissions = m.ManyToManyField(
        'auth.Permission',
        verbose_name='user permissions',
        blank=True,
        help_text='Specific permissions for this user.',
        related_name="flutter_user_set", 
        related_query_name="flutter_user",
    )

class FCMTokens(m.Model):
    id = m.AutoField(primary_key=True)
    token = m.TextField()
    userid = m.ForeignKey(User,on_delete=m.CASCADE)

class BankDetails(m.Model):
    id = m.AutoField(primary_key=True)
    userID = m.ForeignKey(User,on_delete=m.CASCADE)
    bankName = m.TextField()
    accountNumber = m.TextField()
    IBANNumber = m.TextField()
    accountHolderName = m.TextField()

class UserActivity(m.Model):
    ACTIONS = [
        ('search', 'Search Query'),
        ('category_click', 'Clicked Category'),
        ('service_click', 'Clicked Service'),
        ('filter', 'Applied Filter'),
    ]
    user = m.ForeignKey(User, on_delete=m.CASCADE)
    action = m.CharField(max_length=50, choices=ACTIONS)
    metadata = m.JSONField(null=True, blank=True)
    timestamp = m.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.action} - {self.timestamp}"