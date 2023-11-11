from django.db import models


class Trail(models.Model):
    name = models.CharField(max_length=100)
    description = models.CharField(max_length=500)
    distance = models.IntegerField()
    elevation_gain = models.IntegerField()
    elevation_loss = models.IntegerField()
    recommended_experience = models.IntegerField()
    estimated_duration = models.IntegerField()

    def __str__(self):
        return self.name


class Activity(models.Model):
    distance = models.IntegerField()
    elevation_gain = models.IntegerField()
    elevation_loss = models.IntegerField()
    duration = models.IntegerField()
    experience_gain = models.IntegerField()
    user = models.ForeignKey(
        "customusers.CustomUser", related_name="activities", on_delete=models.CASCADE
    )
    created_at = models.DateTimeField(auto_now_add=True)
