from django.urls import path
from blog.views.tags import TagListView

urlpatterns = [
    # path("blog/<int:pk>/comments", views.BlogDetail.as_view(), name="blog_comments"),
    path('tags/', TagListView.as_view(), name='tags'),
]
