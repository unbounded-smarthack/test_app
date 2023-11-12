from django.db.models.signals import post_save
from django.dispatch import receiver

from .models import Trail, calculate_experience


@receiver(post_save, sender=Trail)
def update_recommended_experience(sender, instance, **kwargs):
    post_save.disconnect(update_recommended_experience, sender=Trail)
    try:
        for trail in Trail.objects.all():
            calculate_experience(
                trail.distance,
                trail.elevation_gain,
                trail.elevation_loss,
                trail.estimated_duration,
            )
            trail.save()
    finally:
        post_save.connect(update_recommended_experience, sender=Trail)
