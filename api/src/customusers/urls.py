from django.urls import path

from customusers.views import UserRegistrationView, UserDetailsView

urlpatterns = [
    path("register/", UserRegistrationView.as_view(), name="register"),
    path("user/", UserDetailsView.as_view(), name="user"),
]
