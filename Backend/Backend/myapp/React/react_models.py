from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin

class ReactUserManager(BaseUserManager):
    def create_user(self, id, password=None, **extra_fields):
        user = self.model( **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user
    

class ReactUser(AbstractBaseUser, PermissionsMixin):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)
    email = models.EmailField(max_length=50, unique=True)
    username = models.CharField(max_length=50, unique=True)
    password = models.CharField(max_length=10000)
    profilePicturePath = models.CharField(max_length=255, blank=True, null=True)
    
    groups = models.ManyToManyField(
        'auth.Group',
        verbose_name='groups',
        blank=True,
        help_text='The groups this user belongs to.',
        related_name="react_user_set",  # Unique related_name
        related_query_name="react_user",
    )
    user_permissions = models.ManyToManyField(
        'auth.Permission',
        verbose_name='user permissions',
        blank=True,
        help_text='Specific permissions for this user.',
        related_name="react_user_set",  # Unique related_name
        related_query_name="react_user",
    )
    

    objects = ReactUserManager()
    
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username', 'name']
    
    def __str__(self):
        return self.email
    