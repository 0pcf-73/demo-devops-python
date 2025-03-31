from .views import *
from django.urls import path
from rest_framework import routers

router = routers.DefaultRouter()
router.register(r'users', UserViewSet, basename='users')


urlpatterns = router.urls