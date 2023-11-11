from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from drf_spectacular.utils import extend_schema, OpenApiResponse

from .serializers import UserRegistrationSerializer


class UserRegistrationView(APIView):
    @extend_schema(
        summary="User Registration",
        description="User Registration",
        request=UserRegistrationSerializer,
        responses={
            200: OpenApiResponse(description="Json Response with a message"),
            400: OpenApiResponse(description="Json Response with the error"),
        },
    )
    def post(self, request):
        user_serializers = UserRegistrationSerializer(data=request.data)
        if not user_serializers.is_valid():
            return Response(
                {"errors": user_serializers.errors}, status.HTTP_400_BAD_REQUEST
            )
        user = user_serializers.save()
        return Response(
            {"message": "User successfully registered!"}, status.HTTP_201_CREATED
        )


class UserDetailsView(APIView):
    @extend_schema(
        summary="User Details",
        description="User Details",
        responses={
            200: OpenApiResponse(description="Json Response with a message"),
            400: OpenApiResponse(description="Json Response with the error"),
        },
    )
    def get(self, request):
        user = request.user
        return Response(
            {
                "id": user.id,
                "username": user.username,
                "email": user.email,
                "first_name": user.first_name,
                "last_name": user.last_name,
                "experience": user.experience,
            },
            status.HTTP_200_OK,
        )
