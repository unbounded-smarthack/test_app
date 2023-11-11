from django.urls import path

from hikepal.views import ActivityListView

urlpatterns = [
    path("activities/", ActivityListView.as_view(), name="activities"),
]
