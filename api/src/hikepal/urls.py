from django.urls import path

from hikepal.views import ActivityListView

urlpatterns = [
    path("activities/<int:user_id>/", ActivityListView.as_view(), name="activities"),
]
