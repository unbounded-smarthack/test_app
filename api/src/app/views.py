from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, parsers
from drf_spectacular.utils import extend_schema, OpenApiResponse

from .serializers import UserRegistrationSerializer


class UserRegistrationView(APIView):
    @extend_schema(
        summary='User Registration',
        description="User Registration",
        request=UserRegistrationSerializer,
        responses={
            200: OpenApiResponse(description='Json Response'),
            400: OpenApiResponse(description='Validation error')
        }
    )
    def post(self, request):
        user_serializers = UserRegistrationSerializer(data=request.data)
        if not user_serializers.is_valid():
            return Response({"errors": user_serializers.errors}, status.HTTP_400_BAD_REQUEST)
        user = user_serializers.save()
        return Response({"message": "User successfully registered!"}, status.HTTP_201_CREATED)