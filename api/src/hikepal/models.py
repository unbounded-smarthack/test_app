from django.db import models

from app.settings import EXPERIENCE_GAIN_WEIGHT
from hikepal.utils import calculate_experience


class Trail(models.Model):
    name = models.CharField(max_length=100)
    description = models.CharField(max_length=500)
    distance = models.FloatField()
    elevation_gain = models.IntegerField()
    elevation_loss = models.IntegerField()
    recommended_experience = models.IntegerField()
    estimated_duration = models.IntegerField()

    def __str__(self):
        return self.name


class Activity(models.Model):
    distance = models.FloatField()
    elevation_gain = models.IntegerField()
    elevation_loss = models.IntegerField()
    duration = models.IntegerField()
    experience_gain = models.IntegerField(default=0)
    user = models.ForeignKey(
        "customusers.CustomUser", related_name="activities", on_delete=models.CASCADE
    )
    created_at = models.DateTimeField(auto_now_add=True)

    def calculate_experience_gain(self):
        return EXPERIENCE_GAIN_WEIGHT * calculate_experience(
            self.distance, self.elevation_gain, self.elevation_loss, self.duration
        )

    def __str__(self):
        return f"{self.user.username} - {self.created_at}"
