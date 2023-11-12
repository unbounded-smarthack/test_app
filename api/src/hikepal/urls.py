from django.urls import path
from django.views.decorators.csrf import csrf_exempt

from hikepal.views import ActivityListView, LeaderboardView, TrailSuggestionsView

urlpatterns = [
    path("activities/", csrf_exempt(ActivityListView.as_view()), name="activities"),
    path("leaderboard/", LeaderboardView.as_view(), name="leaderboard"),
    path("suggestions/", TrailSuggestionsView.as_view(), name="suggestions"),
]
