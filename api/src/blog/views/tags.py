from drf_spectacular.utils import extend_schema, OpenApiResponse
from rest_framework.response import Response
from rest_framework.status import HTTP_200_OK, HTTP_201_CREATED, HTTP_400_BAD_REQUEST
from rest_framework.views import APIView

from blog.models import Tag
from blog.serializers import TagSerializer


class TagListView(APIView):
    @extend_schema(
        summary='Tag List',
        description="Tag List",
        request=TagSerializer,
        responses={
            200: OpenApiResponse(description='Json Response with the data'),
        }
    )
    def get(self, request):
        tags = Tag.objects.all()
        serializer = TagSerializer(tags, many=True)
        return Response(serializer.data, status=HTTP_200_OK)

    @extend_schema(
        summary='Tag Create',
        description="Tag Create",
        request=TagSerializer,
        responses={
            201: OpenApiResponse(description='Json Response with the message'),
            400: OpenApiResponse(description='Json Response with the errors'),
        }
    )
    def post(self, request):
        data = {
            'name': request.data.get('name'),
        }
        serializer = TagSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Tag successfully added!"}, status=HTTP_201_CREATED)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)
