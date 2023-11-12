from django.db import models
from django.db.models import Max

from app.settings import (
    DISTANCE_WEIGHT,
    ELEVATION_GAIN_WEIGHT,
    ELEVATION_LOSS_WEIGHT,
    DURATION_WEIGHT,
    SCALE_FACTOR,
    MIN_EXPERIENCE_GAIN_WEIGHT,
)
from hikepal.utils import normalize_value


def calculate_experience(distance, elevation_gain, elevation_loss, duration):
    normalized_distance = normalize_value(distance, Trail.calculate_max_distance())
    normalized_elevation_gain = normalize_value(
        elevation_gain, Trail.calculate_max_elevation_gain()
    )
    normalized_elevation_loss = normalize_value(
        elevation_loss, Trail.calculate_max_elevation_loss()
    )
    normalized_duration = normalize_value(duration, Trail.calculate_max_duration())

    experience = (
        normalized_distance * DISTANCE_WEIGHT
        + normalized_elevation_gain * ELEVATION_GAIN_WEIGHT
        + normalized_elevation_loss * ELEVATION_LOSS_WEIGHT
        + normalized_duration * DURATION_WEIGHT
    ) * SCALE_FACTOR
    return experience


class Trail(models.Model):
    name = models.CharField(max_length=100)
    description = models.CharField(max_length=500)
    distance = models.FloatField()
    elevation_gain = models.IntegerField()
    elevation_loss = models.IntegerField()
    recommended_experience = models.IntegerField()
    estimated_duration = models.IntegerField()

    @classmethod
    def calculate_max_distance(cls):
        return cls.objects.aggregate(Max("distance"))["distance__max"]

    @classmethod
    def calculate_max_elevation_gain(cls):
        return cls.objects.aggregate(Max("elevation_gain"))["elevation_gain__max"]

    @classmethod
    def calculate_max_elevation_loss(cls):
        return cls.objects.aggregate(Max("elevation_loss"))["elevation_loss__max"]

    @classmethod
    def calculate_max_duration(cls):
        return cls.objects.aggregate(Max("estimated_duration"))[
            "estimated_duration__max"
        ]

    def save(self, *args, **kwargs):
        self.recommended_experience = calculate_experience(
            self.distance,
            self.elevation_gain,
            self.elevation_loss,
            self.estimated_duration,
        )
        super().save(*args, **kwargs)

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
        activity_experience = calculate_experience(
            self.distance, self.elevation_gain, self.elevation_loss, self.duration
        )
        experience_gain_weight = max(
            normalize_value(activity_experience - self.user.experience, SCALE_FACTOR),
            MIN_EXPERIENCE_GAIN_WEIGHT,
        )
        experience_gain = experience_gain_weight * activity_experience
        return round(experience_gain)

    def __str__(self):
        return f"{self.user.username} - {self.created_at}"
