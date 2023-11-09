from rest_framework import serializers

from blog.models import Tag


class TagSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tag
        fields = ('id', 'name', 'slug')
        read_only_fields = ('id', 'slug')

    def create(self, validated_data):
        tag = Tag.objects.create(
            name=validated_data['name'],
            slug=validated_data['name'].lower().replace(' ', '-')
        )
        return tag
