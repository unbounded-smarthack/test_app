from django.contrib.auth.models import AbstractUser
from django.db import models


class CustomUser(AbstractUser):
    experience = models.IntegerField(default=0)
