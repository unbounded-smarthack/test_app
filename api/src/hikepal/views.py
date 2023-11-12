from datetime import datetime

from django.db.models import Sum, Q, F
from django.db.models.functions import Abs
from drf_spectacular.utils import extend_schema, OpenApiResponse
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView

from customusers.models import CustomUser
from hikepal.models import Activity, Trail
from hikepal.serializers import ActivitySerializer, TrailSerializer


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
        activities = Activity.objects.filter(user_id=self.request.user.id)
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
        user = self.request.user

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


class LeaderboardView(APIView):
    def get_range_dates(self):
        current_date = datetime.now()
        month = current_date.month
        if month % 3 == 0:
            season_start = datetime(year=current_date.year, month=month - 2, day=1)
            season_end = datetime(year=current_date.year, month=month, day=1)
        elif month % 3 == 1:
            season_start = datetime(year=current_date.year, month=month, day=1)
            season_end = datetime(year=current_date.year, month=month + 2, day=1)
        else:
            season_start = datetime(year=current_date.year, month=month - 1, day=1)
            season_end = datetime(year=current_date.year, month=month + 1, day=1)
        return season_start, season_end

    @extend_schema(
        summary="Leaderboard",
        description="Leaderboard",
        responses={
            200: OpenApiResponse(description="Json Response with the leaderboard"),
        },
    )
    def get(self, request):
        # Get users sorted by sum of experience gained in activities performed in the specific season
        range_start, range_end = self.get_range_dates()
        users = (
            CustomUser.objects.filter(is_superuser=False)
            .annotate(
                experience_gained=Sum(
                    "activities__experience_gain",
                    filter=Q(activities__created_at__range=(range_start, range_end)),
                )
            )
            .order_by("-experience_gained")
            .values("first_name", "last_name", "experience_gained")
        )
        return Response(users, status=status.HTTP_200_OK)


class TrailSuggestionsView(APIView):
    @extend_schema(
        summary="Trail Suggestions",
        description="Trail Suggestions",
        responses={
            200: OpenApiResponse(
                description="Json Response with the trails sorted by experience difference"
            ),
        },
    )
    def get(self, request):
        user = self.request.user
        # Get trails sorted by the modulo of the difference between the user's experience and the recommended experience of the trail
        trails = (
            Trail.objects.all()
            .annotate(
                experience_difference=Abs(F("recommended_experience") - user.experience)
            )
            .order_by("experience_difference")
        )
        serializer = TrailSerializer(trails, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
