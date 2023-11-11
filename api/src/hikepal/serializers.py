from rest_framework import serializers

from hikepal.models import Activity


class ActivitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Activity
        fields = (
            "id",
            "distance",
            "elevation_gain",
            "elevation_loss",
            "duration",
            "experience_gain",
            "user",
            "created_at",
        )
