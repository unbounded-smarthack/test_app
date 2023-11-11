from drf_spectacular.utils import extend_schema, OpenApiResponse
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView

from hikepal.models import Activity
from hikepal.serializers import ActivitySerializer


class ActivityListView(APIView):
    @extend_schema(
        summary="Activity List",
        description="Activity List",
        request=ActivitySerializer,
        responses={
            200: OpenApiResponse(description="Json Response with all the activities"),
        },
    )
    def get(self, request):
        activities = Activity.objects.all()
        serializer = ActivitySerializer(activities, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @extend_schema(
        summary="Activity Create",
        description="Activity Create",
        request=ActivitySerializer,
        responses={
            201: OpenApiResponse(description="Json Response with the experience gain"),
            400: OpenApiResponse(description="Json Response with the error"),
        },
    )
    def post(self, request):
        serializer = ActivitySerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(
                serializer.data["experience_gain"], status=status.HTTP_201_CREATED
            )
        return Response(
            {"error": serializer.errors}, status=status.HTTP_400_BAD_REQUEST
        )
