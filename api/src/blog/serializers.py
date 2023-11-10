import re

from rest_framework import serializers

from blog.models import Tag, Category


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
    def update(self, instance, validated_data):
        instance.name = validated_data.get('name', instance.name)
        instance.slug = re.sub("[^a-z0-9-]", "", instance.name.lower().replace(" ", "-"))
        instance.save()
        return instance

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ('id', 'name', 'slug')
        read_only_fields = ('id', 'slug')

    def create(self, validated_data):
        name = validated_data['name']
        slug = re.sub("[^a-z0-9-]", "", name.lower().replace(" ", "-"))
        category = Category.objects.create(
            name=name,
            slug=slug
        )
        return category

    def update(self, instance, validated_data):
        instance.name = validated_data.get('name', instance.name)
        instance.slug = re.sub("[^a-z0-9-]", "", instance.name.lower().replace(" ", "-"))
        instance.save()
        return instance
