from django.urls import path

from hikepal.views import ActivityListView, LeaderboardView, TrailSuggestionsView

urlpatterns = [
    path("activities/", ActivityListView.as_view(), name="activities"),
    path("leaderboard/", LeaderboardView.as_view(), name="leaderboard"),
    path("suggestions/", TrailSuggestionsView.as_view(), name="suggestions"),
]
