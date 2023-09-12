from django.urls import path

from . import views

# Comment added as test
urlpatterns = [
    path('', views.index, name='index'),
]
