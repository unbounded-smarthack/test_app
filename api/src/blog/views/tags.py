from drf_spectacular.utils import extend_schema, OpenApiResponse
from rest_framework import parsers
from rest_framework.response import Response
from rest_framework.status import HTTP_200_OK, HTTP_201_CREATED, HTTP_400_BAD_REQUEST
from rest_framework.views import APIView

from blog.models import Tag
from blog.serializers import TagSerializer


class TagListView(APIView):
    parser_classes = [parsers.FormParser]
    @extend_schema(
        summary='Tag List and Create',
        description="Tag List and Create",
        request=TagSerializer,
        responses={
            200: OpenApiResponse(description='Json Response'),
            201: OpenApiResponse(description='Json Response')
        }
    )
    def get(self, request):
        tags = Tag.objects.all()
        serializer = TagSerializer(tags, many=True)
        return Response(serializer.data, status=HTTP_200_OK)

    def post(self, request):
        data = {
            'name': request.data.get('name'),
        }
        serializer = TagSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Tag successfully added!"}, status=HTTP_201_CREATED)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)
