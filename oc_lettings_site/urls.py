from django.contrib import admin
from django.urls import path, include


def trigger_error(request):
    return 1 / 0


urlpatterns = [
    path('sentry-debug/', trigger_error),
    path('', include('main_app.urls')),
    path('lettings/', include('lettings.urls')),
    path('profiles/', include('profiles.urls')),
    path('admin/', admin.site.urls),
]
