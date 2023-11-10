from drf_spectacular.utils import extend_schema, OpenApiResponse
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.status import HTTP_200_OK, HTTP_201_CREATED, HTTP_400_BAD_REQUEST
from rest_framework.views import APIView

from blog.models import Category
from blog.serializers import CategorySerializer


class CategoryListView(APIView):
    @extend_schema(
        summary='Category List',
        description="Category List",
        request=CategorySerializer,
        responses={
            200: OpenApiResponse(description='Json Response with the data'),
        }
    )
    def get(self, request):
        categories = Category.objects.all()
        serializer = CategorySerializer(categories, many=True)
        return Response(serializer.data, status=HTTP_200_OK)

    @extend_schema(
        summary='Category Create',
        description="Category Create",
        request=CategorySerializer,
        responses={
            201: OpenApiResponse(description='Json Response with the message'),
            400: OpenApiResponse(description='Json Response with the errors'),
        }
    )
    def post(self, request):
        data = {
            'name': request.data.get('name'),
        }
        serializer = CategorySerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Category successfully added!"}, status=HTTP_201_CREATED)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)


class CategoryDetailView(APIView):
    @extend_schema(
        summary='Category Detail',
        description="Category Detail",
        request=CategorySerializer,
        responses={
            200: OpenApiResponse(description='Json Response with the data'),
        }
    )
    def get(self, request, pk):
        category = get_object_or_404(Category, pk=pk)
        serializer = CategorySerializer(category)
        return Response(serializer.data, status=HTTP_200_OK)

    @extend_schema(
        summary='Category Update',
        description="Category Update",
        request=CategorySerializer,
        responses={
            200: OpenApiResponse(description='Json Response with the message'),
            400: OpenApiResponse(description='Json Response with the errors'),
        }
    )
    def put(self, request, pk):
        category = get_object_or_404(Category, pk=pk)
        serializer = CategorySerializer(category, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Category successfully updated!"}, status=HTTP_200_OK)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)

    @extend_schema(
        summary='Category Delete',
        description="Category Delete",
        request=CategorySerializer,
        responses={
            200: OpenApiResponse(description='Json Response with the message'),
        }
    )
    def delete(self, request, pk):
        category = get_object_or_404(Category, pk=pk)
        category.delete()
        return Response({"message": "Category successfully deleted!"}, status=HTTP_200_OK)
