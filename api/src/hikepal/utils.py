from django.db.models import Max

from app.settings import (
    DISTANCE_WEIGHT,
    ELEVATION_GAIN_WEIGHT,
    ELEVATION_LOSS_WEIGHT,
    DURATION_WEIGHT,
)
from hikepal.models import Trail


def calculate_max_distance():
    return Trail.objects.aggregate(Max("distance"))["distance__max"]


def calculate_max_elevation_gain():
    return Trail.objects.aggregate(Max("elevation_gain"))["elevation_gain__max"]


def calculate_max_elevation_loss():
    return Trail.objects.aggregate(Max("elevation_loss"))["elevation_loss__max"]


def calculate_max_duration():
    return Trail.objects.aggregate(Max("estimated_duration"))["estimated_duration__max"]


def normalize_value(value, max_value):
    return min(value / max_value, 1.0)


def calculate_experience(distance, elevation_gain, elevation_loss, duration):
    normalized_distance = normalize_value(distance, calculate_max_distance())
    normalized_elevation_gain = normalize_value(
        elevation_gain, calculate_max_elevation_gain()
    )
    normalized_elevation_loss = normalize_value(
        elevation_loss, calculate_max_elevation_loss()
    )
    normalized_duration = normalize_value(duration, calculate_max_duration())

    experience = (
        normalized_distance * DISTANCE_WEIGHT
        + normalized_elevation_gain * ELEVATION_GAIN_WEIGHT
        + normalized_elevation_loss * ELEVATION_LOSS_WEIGHT
        + normalized_duration * DURATION_WEIGHT
    )
    return max(experience, 25)
