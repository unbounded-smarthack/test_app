import re

from rest_framework import serializers

from blog.models import Tag


class TagSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tag
        fields = ('id', 'name', 'slug')
        read_only_fields = ('id', 'slug')

    def create(self, validated_data):
        name = validated_data['name']
        slug = re.sub("[^a-z0-9-]", "", name.lower().replace(" ", "-"))
        tag = Tag.objects.create(
            name=name,
            slug=slug
        )
        return tag
