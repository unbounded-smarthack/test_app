from django.urls import path

from hikepal.views import ActivityListView, LeaderboardView

urlpatterns = [
    path("activities/<int:user_id>/", ActivityListView.as_view(), name="activities"),
    path("leaderboard/", LeaderboardView.as_view(), name="leaderboard"),
]
