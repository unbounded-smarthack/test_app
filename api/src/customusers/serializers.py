from django.contrib.auth.hashers import make_password
from rest_framework import serializers

from customusers.models import CustomUser


class UserRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(
        required=True,
        style={"input_type": "password", "placeholder": "Password"},
        write_only=True,
    )

    class Meta:
        model = CustomUser
        fields = ("username", "first_name", "last_name", "email", "password")

    def create(self, validated_data):
        validated_data["password"] = make_password(validated_data.get("password"))
        return super(UserRegistrationSerializer, self).create(validated_data)
