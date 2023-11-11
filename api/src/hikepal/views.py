from drf_spectacular.utils import extend_schema, OpenApiResponse
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView

from customusers.models import CustomUser
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
    def get(self, request, user_id):
        activities = Activity.objects.filter(user_id=user_id)
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
    def post(self, request, user_id):
        user = get_object_or_404(CustomUser, pk=user_id)

        serializer = ActivitySerializer(data=request.data)
        if serializer.is_valid():
            serializer.validated_data["user"] = user
            serializer.save()

            user.experience += serializer.data["experience_gain"]
            user.save()

            return Response(
                serializer.data["experience_gain"], status=status.HTTP_201_CREATED
            )
        return Response(
            {"error": serializer.errors}, status=status.HTTP_400_BAD_REQUEST
        )
