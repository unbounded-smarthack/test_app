from django.urls import re_path

from blog import consumers

websocket_urlpatterns = [
    re_path(r'ws/blog/(?P<blog_id>\d+)/comments$', consumers.CommentConsumer.as_asgi()),
]
