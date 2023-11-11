from django.urls import path
from rest_framework.authtoken import views

from customusers.views import UserRegistrationView, UserDetailsView

urlpatterns = [
    path("register/", UserRegistrationView.as_view(), name="register"),
    path("user/", UserDetailsView.as_view(), name="user"),
    path("token-auth/", views.obtain_auth_token, name="token-auth"),
]
