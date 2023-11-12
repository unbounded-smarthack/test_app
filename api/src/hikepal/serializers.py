from rest_framework import serializers

from hikepal.models import Activity, Trail


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
        read_only_fields = ("id", "created_at", "experience_gain", "user")

    def create(self, validated_data):
        activity = Activity.objects.create(**validated_data)
        activity.experience_gain = activity.calculate_experience_gain()
        activity.save()
        return activity


class TrailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Trail
        fields = (
            "id",
            "name",
            "distance",
            "elevation_gain",
            "elevation_loss",
            "estimated_duration",
            "recommended_experience",
        )
        read_only_fields = ("id", "recommended_experience", "created_at")
