from django.urls import path

from blog.views.categories import CategoryListView, CategoryDetailView
from blog.views.tags import TagListView, TagDetailView

urlpatterns = [
    # path("blog/<int:pk>/comments", views.BlogDetail.as_view(), name="blog_comments"),
    path('tags/', TagListView.as_view(), name='tags'),
    path('tags/<int:pk>/', TagDetailView.as_view(), name='tag_detail'),
    path('categories', CategoryListView.as_view(), name='categories'),
    path('categories/<int:pk>/', CategoryDetailView.as_view(), name='category_detail'),
]
