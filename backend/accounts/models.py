from django.db import models #for access to all database field types
from django.contrib.auth.models import AbstractUser #Django's built-in user template 

class User(AbstractUser):
    email = models.EmailField(unique=True) #unique login identifier
    is_verified = models.BooleanField(default=False) #starts False
    verification_token = models.CharField(max_length=100, blank=True, null=True) # UUID token: empty until signup, cleared after verification

    USERNAME_FIELD = 'email' #use email to log in instead of username
    REQUIRED_FIELDS = ['username'] #username is required when creating a user

    def __str__(self):
        return self.email #shows email instead of "User object (1)" in admin panel